import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:irunner_ios/achievement_system.dart';
import 'package:irunner_ios/achievements_page.dart';
import 'package:irunner_ios/result_page.dart';
import 'package:irunner_ios/utils.dart';
import 'package:latlong2/latlong.dart';

import 'achievements_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iRunner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _currentPosition;
  bool _isLoading = true;
  bool _isRunning = false;
  final List<LatLng> _trace = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  final MapController _mapController = MapController();
  Timer? _timer;
  int _durationInSeconds = 0;
  double _distanceInMeters = 0.0;
  final AchievementManager _achievementManager = AchievementManager();

  @override
  void initState() {
    super.initState();
    _achievementManager.loadProgress();
    _determinePosition();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _timer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _toggleRunning() async {
    if (_isRunning) {
      // 结束跑步
      _positionStreamSubscription?.cancel();
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });

      final result = RunResult(
        trace: List.from(_trace),
        durationInSeconds: _durationInSeconds,
        distanceInMeters: _distanceInMeters,
      );

      final newlyUnlocked = await _achievementManager.checkAchievements(result);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            result: result,
            newlyUnlocked: newlyUnlocked,
          ),
        ),
      );
    } else {
      // 开始跑步
      setState(() {
        _isRunning = true;
        _trace.clear();
        _distanceInMeters = 0.0;
        _durationInSeconds = 0;

        if (_currentPosition != null) {
          _trace.add(_currentPosition!);
        }
        
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            _durationInSeconds++;
          });
        });

        _positionStreamSubscription =
            Geolocator.getPositionStream().listen((Position position) {
          if (!mounted) return;
          setState(() {
            final newPosition = LatLng(position.latitude, position.longitude);
            if (_trace.isNotEmpty) {
              final lastPosition = _trace.last;
              _distanceInMeters += Geolocator.distanceBetween(
                lastPosition.latitude,
                lastPosition.longitude,
                newPosition.latitude,
                newPosition.longitude,
              );
            }
            _currentPosition = newPosition;
            _trace.add(_currentPosition!);
            _mapController.move(_currentPosition!, 16.0);
          });
        });
      });
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iRunner - 跑步'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AchievementsPage(achievementManager: _achievementManager),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _currentPosition == null
                  ? const Center(child: Text('无法获取位置信息'))
                  : FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _currentPosition!,
                        initialZoom: 16.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://wprd0{s}.is.autonavi.com/appmaptile?style=7&x={x}&y={y}&z={z}',
                          subdomains: const ['1', '2', '3', '4'],
                        ),
                        if (_trace.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _trace,
                                strokeWidth: 4.0,
                                color: Colors.purple,
                              ),
                            ],
                          ),
                        if (_currentPosition != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: _currentPosition!,
                                width: 80,
                                height: 80,
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
          if (_isRunning)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('时长', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text(formatDuration(_durationInSeconds), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('距离', style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text(formatDistance(_distanceInMeters), style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: _toggleRunning,
                child: Icon(_isRunning ? Icons.stop : Icons.play_arrow),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
