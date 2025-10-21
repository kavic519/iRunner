import 'package:flutter/material.dart';
import '../models/run_session.dart';
import '../services/history_service.dart';
import '../widgets/history_list_item.dart';
import 'run_detail_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryService _historyService = HistoryService();
  late Future<List<RunSession>> _runsFuture;

  @override
  void initState() {
    super.initState();
    _loadRuns();
  }

  void _loadRuns() {
    setState(() {
      _runsFuture = _historyService.getRuns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('跑步历史'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<RunSession>>(
        future: _runsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('加载失败: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                '暂无跑步记录',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            final runs = snapshot.data!;
            return ListView.builder(
              itemCount: runs.length,
              itemBuilder: (context, index) {
                final run = runs[index];
                return HistoryListItem(
                  run: run,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RunDetailPage(run: run),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
