import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/achievement.dart';

class AchievementsPage extends StatefulWidget {
  final int userId;
  const AchievementsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final ApiService api = ApiService();
  List<Achievement>? items;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await api.fetchAchievements(widget.userId);
      setState(() {
        items = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(body: Center(child: Text('错误：$error')));

    return Scaffold(
      appBar: AppBar(title: const Text('成就')),
      body: ListView.separated(
        itemCount: items?.length ?? 0,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final a = items![i];
          return ListTile(
            leading: Icon(a.isUnlocked ? Icons.emoji_events : Icons.lock),
            title: Text(a.name),
            subtitle: Text(a.description ?? ''),
            trailing: a.progress != null ? Text('${(a.progress! * 100).toStringAsFixed(0)}%') : null,
          );
        },
      ),
    );
  }
}