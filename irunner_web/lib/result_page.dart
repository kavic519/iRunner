import 'package:flutter/material.dart';
import 'package:irunner_ios/achievement_system.dart';
import 'package:irunner_ios/utils.dart';
import 'package:latlong2/latlong.dart';

class RunResult {
  final List<LatLng> trace;
  final int durationInSeconds;
  final double distanceInMeters;

  RunResult({
    required this.trace,
    required this.durationInSeconds,
    required this.distanceInMeters,
  });

  String get avgSpeed {
    if (durationInSeconds == 0) return '0.00';
    final speed = (distanceInMeters / 1000) / (durationInSeconds / 3600);
    return speed.toStringAsFixed(2);
  }
}

class ResultPage extends StatefulWidget {
  final RunResult result;
  final List<Achievement> newlyUnlocked;

  const ResultPage({
    super.key,
    required this.result,
    this.newlyUnlocked = const [],
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    super.initState();
    if (widget.newlyUnlocked.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AchievementUnlockedDialog(achievements: widget.newlyUnlocked);
          },
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跑步结果'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('本次跑步结束！', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            Text('距离: ${formatDistance(widget.result.distanceInMeters)}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('时长: ${formatDuration(widget.result.durationInSeconds)}',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('平均速度: ${widget.result.avgSpeed} km/h',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
