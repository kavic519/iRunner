import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/run_session.dart';

class HistoryListItem extends StatelessWidget {
  final RunSession run;
  final VoidCallback onTap;

  const HistoryListItem({
    Key? key,
    required this.run,
    required this.onTap,
  }) : super(key: key);

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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('yyyy年MM月dd日 HH:mm').format(run.date.toLocal()),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStat('距离', '${(run.distanceInMeters / 1000).toStringAsFixed(2)} km'),
                  _buildStat('时长', _formatDuration(run.duration)),
                  _buildStat('配速', _formatPace(run.paceInSecondsPerKm)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      ],
    );
  }
}
