import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../models/run_session.dart';

class RunDetailPage extends StatefulWidget {
  final RunSession run;

  const RunDetailPage({Key? key, required this.run}) : super(key: key);

  @override
  State<RunDetailPage> createState() => _RunDetailPageState();
}

class _RunDetailPageState extends State<RunDetailPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final polylinePoints = widget.run.route.map((c) => LatLng(c.latitude, c.longitude)).toList();
      if (polylinePoints.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(polylinePoints);
        _mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(50.0),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final parts = <String>[];
    if (d.inHours > 0) parts.add('${d.inHours}h');
    if (d.inMinutes.remainder(60) > 0) parts.add('${d.inMinutes.remainder(60)}m');
    parts.add('${d.inSeconds.remainder(60)}s');
    return parts.join(' ');
  }

  String _formatPace(double secondsPerKm) {
    if (secondsPerKm.isInfinite || secondsPerKm.isNaN) return "N/A";
    final minutes = (secondsPerKm / 60).floor();
    final seconds = (secondsPerKm % 60).round();
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')} /km";
  }

  @override
  Widget build(BuildContext context) {
    final polylinePoints = widget.run.route.map((c) => LatLng(c.latitude, c.longitude)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy-MM-dd').format(widget.run.date.toLocal())),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: polylinePoints.isNotEmpty ? polylinePoints.first : const LatLng(0, 0),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://wprd0{s}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}",
                  subdomains: const ['1', '2', '3', '4'],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylinePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  _buildStatCard('距离', '${(widget.run.distanceInMeters / 1000).toStringAsFixed(2)} km'),
                  _buildStatCard('时长', _formatDuration(widget.run.duration)),
                  _buildStatCard('配速', _formatPace(widget.run.paceInSecondsPerKm)),
                  _buildStatCard('日期', DateFormat('yyyy/MM/dd\nHH:mm').format(widget.run.date.toLocal())),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      elevation: 2,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
