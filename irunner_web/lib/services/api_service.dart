import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/run_session.dart';
import '../models/user.dart';
import '../models/community.dart';
import '../models/achievement.dart';

class ApiService {
  final String baseUrl;
  ApiService({this.baseUrl = 'http://www.kavic.xyz:8080/api'});

  Map<String, dynamic> _decode(http.Response resp) {
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return json.decode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final uri = Uri.parse('$baseUrl/users/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final body = _decode(resp);
    if (body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    } else {
      throw Exception(body['message'] ?? '登录失败');
    }
  }

  Future<Map<String, dynamic>> register(String username, String password, String email, String nickName) async {
    final uri = Uri.parse('$baseUrl/users/register');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'nickName': nickName,
      }),
    );
    final body = _decode(resp);
    if (body['success'] == true) {
      return body['data'] as Map<String, dynamic>;
    } else {
      throw Exception(body['message'] ?? '注册失败');
    }
  }

  Future<List<User>> fetchLeaderboard({String type = 'distance', int limit = 20}) async {
    final uri = Uri.parse('$baseUrl/users/leaderboard?type=$type&limit=$limit');
    final resp = await http.get(uri);
    final body = _decode(resp);
    final list = (body['data'] as List?) ?? [];
    return list.map((e) => User.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<User> fetchUser(int userId) async {
    final resp = await http.get(Uri.parse('$baseUrl/users/$userId'));
    final body = _decode(resp);
    return User.fromJson(Map<String, dynamic>.from(body['data'] as Map));
  }

  Future<List<Community>> fetchCommunities({int? userId, int? limit}) async {
    final params = <String>[];
    if (userId != null) params.add('userId=$userId');
    if (limit != null) params.add('limit=$limit');
    final uri = Uri.parse('$baseUrl/communities' + (params.isNotEmpty ? '?${params.join('&')}' : ''));
    final resp = await http.get(uri);
    final body = _decode(resp);
    final list = (body['data'] as List?) ?? [];
    return list.map((e) => Community.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<Achievement>> fetchAchievements(int userId) async {
    final uri = Uri.parse('$baseUrl/achievements/users/$userId');
    final resp = await http.get(uri);
    final body = _decode(resp);
    final list = (body['data'] as List?) ?? [];
    return list.map((e) => Achievement.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<List<RunSession>> fetchRunsForUser(int userId, {int? limit}) async {
    final params = <String>[];
    if (limit != null) params.add('limit=$limit');
    final uri = Uri.parse('$baseUrl/runs/users/$userId' + (params.isNotEmpty ? '?${params.join('&')}' : ''));
    final resp = await http.get(uri);
    final body = _decode(resp);
    final list = (body['data'] as List?) ?? [];
    return list.map((e) => RunSession.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> joinCommunity(int communityId, int userId) async {
    final uri = Uri.parse('$baseUrl/communities/$communityId/join?userId=$userId');
    final resp = await http.post(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('加入圈子失败: ${resp.body}');
    }
  }

  Future<void> leaveCommunity(int communityId, int userId) async {
    final uri = Uri.parse('$baseUrl/communities/$communityId/leave?userId=$userId');
    final resp = await http.post(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('退出圈子失败: ${resp.body}');
    }
  }

  Future<List<Community>> searchCommunities(String keyword, {int? userId}) async {
    final params = <String>['keyword=$keyword'];
    if (userId != null) params.add('userId=$userId');
    final uri = Uri.parse('$baseUrl/communities/search?${params.join('&')}');
    final resp = await http.get(uri);
    final body = _decode(resp);
    final list = (body['data'] as List?) ?? [];
    return list.map((e) => Community.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> deleteCommunity(int communityId) async {
    final uri = Uri.parse('$baseUrl/communities/$communityId');
    final resp = await http.delete(uri);
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('删除圈子失败: ${resp.body}');
    }
  }

  Future<void> createCommunity({
    required String name,
    String? description,
    String? imageUrl,
    required int creatorId,
    bool isPublic = true,
  }) async {
    final uri = Uri.parse('$baseUrl/communities?creatorId=$creatorId');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'isPublic': isPublic,
      }),
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('创建圈子失败: ${resp.body}');
    }
  }
}