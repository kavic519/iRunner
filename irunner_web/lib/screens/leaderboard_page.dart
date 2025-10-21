import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final ApiService api = ApiService();
  List<User>? users;
  String? error;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final list = await api.fetchLeaderboard(limit: 50);
      setState(() {
        users = list;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  Widget _avatar(User u) {
    final url = u.avatarUrl;
    if (url != null && url.isNotEmpty && (url.startsWith('http://') || url.startsWith('https://'))) {
      return CircleAvatar(backgroundImage: NetworkImage(url));
    }
    final label = (u.nickName ?? u.username);
    return CircleAvatar(child: Text(label.isEmpty ? '?' : label[0].toUpperCase()));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(body: Center(child: Text('错误：$error')));

    return Scaffold(
      appBar: AppBar(title: const Text('排行榜')),
      body: ListView.separated(
        itemCount: users?.length ?? 0,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final u = users![i];
          return ListTile(
            leading: _avatar(u),
            title: Text(u.nickName ?? u.username),
            subtitle: Text('总里程: ${u.totalDistance ?? 0} · 跑步次数: ${u.totalRuns ?? 0}'),
            trailing: Text('#${i + 1}'),
          );
        },
      ),
    );
  }
}