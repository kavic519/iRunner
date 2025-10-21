import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/run_session.dart';

class HistoryService {
  static const _historyKey = 'run_history';

  Future<void> saveRun(RunSession run) async {
    final prefs = await SharedPreferences.getInstance();
    final List<RunSession> runs = await getRuns();
    
    // Avoid adding duplicates if the run id already exists
    runs.removeWhere((existingRun) => existingRun.id == run.id);
    runs.add(run);

    // Sort runs by date, most recent first
    runs.sort((a, b) => b.date.compareTo(a.date));

    List<String> runsJson = runs.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList(_historyKey, runsJson);
  }

  Future<List<RunSession>> getRuns() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? runsJson = prefs.getStringList(_historyKey);

    if (runsJson == null) {
      return [];
    }

    return runsJson.map((runString) {
      final Map<String, dynamic> runMap = jsonDecode(runString);
      return RunSession.fromJson(runMap);
    }).toList();
  }
  
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
