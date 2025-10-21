import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:irunner_ios/achievement_system.dart';
import 'package:irunner_ios/result_page.dart';
import 'package:irunner_ios/screens/history_page.dart';
import 'package:irunner_ios/screens/home_page.dart';
import 'package:irunner_ios/screens/run_detail_page.dart';
import 'package:irunner_ios/screens/runs_page.dart';
import 'package:irunner_ios/screens/user_page.dart';
import 'package:irunner_ios/utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'models/run_session.dart';
import 'screens/leaderboard_page.dart';
import 'services/history_service.dart';
import 'screens/communities_page.dart';
import 'screens/achievements_page.dart';
import 'services/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserService(),
      child: MaterialApp(
        title: 'iRunner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
        routes: {
          '/leaderboard': (_) => const LeaderboardPage(),
          '/communities': (_) => const CommunitiesPage(),
          '/map': (_) => const MapPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/achievements') {
            final args = settings.arguments;
            final userId = (args is int) ? args : UserService().currentUserId ?? 1;
            return MaterialPageRoute(builder: (_) => AchievementsPage(userId: userId));
          }
          if (settings.name == '/runs') {
            final args = settings.arguments;
            final userId = (args is int) ? args : UserService().currentUserId ?? 1;
            return MaterialPageRoute(builder: (_) => RunsPage(userId: userId));
          }
          if (settings.name == '/user') {
            final args = settings.arguments;
            final userId = (args is int) ? args : UserService().currentUserId ?? 1;
            return MaterialPageRoute(builder: (_) => UserPage(userId: userId));
          }
          if (settings.name == '/run_detail') {
            final args = settings.arguments;
            if (args is RunSession) {
              return MaterialPageRoute(builder: (_) => RunDetailPage(run: args));
            }
          }
          return null;
        },
      ),
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
  bool _isPaused = false;
  final List<LatLng> _trace = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  final MapController _mapController = MapController();
  Timer? _timer;
  int _durationInSeconds = 0;
  double _distanceInMeters = 0.0;
  final AchievementManager _achievementManager = AchievementManager();
  final HistoryService _historyService = HistoryService();

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

      // Create RunSession
      final runSession = RunSession(
        id: DateTime.now().toIso8601String(), // Using timestamp as a simple unique ID
        date: DateTime.now(),
        distanceInMeters: _distanceInMeters,
        durationInSeconds: _durationInSeconds,
        route: _trace.map((latLng) => Coordinate(latitude: latLng.latitude, longitude: latLng.longitude)).toList(),
      );

      // Save the run session
      await _historyService.saveRun(runSession);

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
        _isPaused = false;
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

  void _togglePause() {
    if (!_isRunning) return;

    setState(() {
      _isPaused = !_isPaused;

      if (_isPaused) {
        _timer?.cancel();
        _positionStreamSubscription?.pause();
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (!mounted) {
            timer.cancel();
            return;
          }
          setState(() {
            _durationInSeconds++;
          });
        });
        _positionStreamSubscription?.resume();
      }
    });
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 检查位置服务是否启用
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;

      // 显示对话框提示用户开启位置服务
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('位置服务已禁用'),
          content: const Text('请开启位置服务以使用跑步追踪功能'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Geolocator.openLocationSettings(); // 跳转到位置设置
              },
              child: const Text('去设置'),
            ),
          ],
        ),
      );

      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        // 显示权限被拒绝的提示
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('位置权限被拒绝')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      // 显示永久拒绝的提示，引导用户去设置
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('位置权限被永久拒绝'),
          content: const Text('请在应用设置中开启位置权限'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Geolocator.openAppSettings(); // 跳转到应用设置
              },
              child: const Text('去设置'),
            ),
          ],
        ),
      );
      return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('获取位置失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('iRunner - 跑步'),
          actions: [
            IconButton(
              icon: const Icon(Icons.leaderboard),
              onPressed: () => Navigator.pushNamed(context, '/leaderboard'),
            ),
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
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
            child: _isRunning
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'pause_resume_button',
                        onPressed: _togglePause,
                        child: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                      ),
                      FloatingActionButton(
                        heroTag: 'stop_button',
                        onPressed: _toggleRunning,
                        backgroundColor: Colors.red,
                        child: const Icon(Icons.stop),
                      ),
                    ],
                  )
                : Center(
                    child: FloatingActionButton(
                      heroTag: 'start_button',
                      onPressed: _toggleRunning,
                      child: const Icon(Icons.play_arrow),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
