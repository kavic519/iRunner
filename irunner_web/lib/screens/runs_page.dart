import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/run_session.dart';

class RunsPage extends StatefulWidget {
  final int userId;
  const RunsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<RunsPage> createState() => _RunsPageState();
}

class _RunsPageState extends State<RunsPage> {
  final ApiService api = ApiService();
  List<RunSession>? runs;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await api.fetchRunsForUser(widget.userId, limit: 50);
      // ApiService may return List<RunSession> or List<Map>
      List<RunSession> list;
      if (data is List<RunSession>) {
        list = data;
      } else {
        list = (data as List<dynamic>)
            .map((e) => RunSession.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      if (!mounted) return;
      setState(() {
        runs = list;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  String _formatDuration(int? s) {
    if (s == null) return '--';
    final minutes = s ~/ 60;
    final seconds = s % 60;
    return '${minutes}m ${seconds}s';
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    return d.toLocal().toString().split('.')[0];
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (error != null) return Scaffold(body: Center(child: Text('错误：$error')));

    return Scaffold(
      appBar: AppBar(title: const Text('跑步记录')),
      body: ListView.separated(
        itemCount: runs?.length ?? 0,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final r = runs![i];
          final distanceKm = (r.distanceInMeters != null) ? (r.distanceInMeters! / 1000) : null;
          final dateStr = _formatDate(r.date);
          return ListTile(
            title: Text(distanceKm != null ? '${distanceKm.toStringAsFixed(2)} km' : '未知距离'),
            subtitle: Text('${_formatDuration(r.durationInSeconds)} · $dateStr'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('跑步详情'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('日期: $dateStr'),
                      Text('距离: ${distanceKm != null ? distanceKm.toStringAsFixed(2) + " km" : "未知"}'),
                      Text('时长: ${_formatDuration(r.durationInSeconds)}'),
                      if (r.distanceInMeters != null && r.durationInSeconds != null && r.distanceInMeters! > 0)
                        Text('平均配速: ${(r.durationInSeconds! / (r.distanceInMeters! / 1000)).toStringAsFixed(1)} s/km'),
                    ],
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('关闭')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}