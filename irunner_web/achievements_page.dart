import 'package:flutter/material.dart';
import 'package:irunner_ios/achievement_system.dart';

class AchievementsPage extends StatefulWidget {
  final AchievementManager achievementManager;

  const AchievementsPage({super.key, required this.achievementManager});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  void initState() {
    super.initState();
    // 确保数据是最新的
    widget.achievementManager.loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的成就'),
      ),
      body: ListView.builder(
        itemCount: widget.achievementManager.allAchievements.length,
        itemBuilder: (context, index) {
          final achievement = widget.achievementManager.allAchievements[index];
          return ListTile(
            leading: Icon(
              achievement.isUnlocked ? Icons.check_circle : Icons.circle_outlined,
              color: achievement.isUnlocked ? Colors.green : Colors.grey,
            ),
            title: Text(
              achievement.name,
              style: TextStyle(
                color: achievement.isUnlocked ? Colors.black : Colors.grey,
                fontWeight: achievement.isUnlocked ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              achievement.description,
               style: TextStyle(
                color: achievement.isUnlocked ? Colors.black54 : Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
