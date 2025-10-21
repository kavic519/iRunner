import 'package:flutter/material.dart';
import 'package:irunner_ios/result_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  bool isUnlocked;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    this.isUnlocked = false,
  });
}

class AchievementManager {
  // 定义所有的成就
  final List<Achievement> allAchievements = [
    Achievement(
      id: 'first_run',
      name: '初次征程',
      description: '完成你的第一次跑步',
    ),
    Achievement(
      id: 'one_kilometer',
      name: '一公里跑者',
      description: '单次跑步距离超过 1 公里',
    ),
    Achievement(
      id: 'ten_minutes',
      name: '耐力跑者',
      description: '单次跑步时长超过 10 分钟',
    ),
     Achievement(
      id: 'three_runs',
      name: '坚持不懈',
      description: '累计跑步次数达到 3 次',
    ),
  ];

  Future<void> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var achievement in allAchievements) {
      achievement.isUnlocked = prefs.getBool(achievement.id) ?? false;
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (var achievement in allAchievements) {
      await prefs.setBool(achievement.id, achievement.isUnlocked);
    }
  }

  Future<List<Achievement>> checkAchievements(RunResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Achievement> newlyUnlocked = [];

    // 1. 更新累计数据
    int totalRuns = (prefs.getInt('totalRuns') ?? 0) + 1;
    await prefs.setInt('totalRuns', totalRuns);
    
    // 2. 检查各项成就
    for (var achievement in allAchievements) {
      if (!achievement.isUnlocked) {
        bool unlockedNow = false;
        switch (achievement.id) {
          case 'first_run':
            if (totalRuns >= 1) unlockedNow = true;
            break;
          case 'one_kilometer':
            if (result.distanceInMeters >= 1000) unlockedNow = true;
            break;
          case 'ten_minutes':
            if (result.durationInSeconds >= 600) unlockedNow = true;
            break;
          case 'three_runs':
            if (totalRuns >= 3) unlockedNow = true;
            break;
        }

        if (unlockedNow) {
          achievement.isUnlocked = true;
          newlyUnlocked.add(achievement);
        }
      }
    }

    // 3. 保存进度
    if (newlyUnlocked.isNotEmpty) {
      await _saveProgress();
    }

    return newlyUnlocked;
  }
}

class AchievementUnlockedDialog extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementUnlockedDialog({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('🎉 新成就解锁！'),
      content: SingleChildScrollView(
        child: ListBody(
          children: achievements.map((ach) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ach.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(ach.description, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('太棒了！'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
