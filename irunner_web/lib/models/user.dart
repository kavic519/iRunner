class User {
  final int id;
  final String username;
  final String? nickName;
  final String? avatarUrl;
  final int? totalRuns;
  final double? totalDistance;
  final int? totalDuration;

  User({
    required this.id,
    required this.username,
    this.nickName,
    this.avatarUrl,
    this.totalRuns,
    this.totalDistance,
    this.totalDuration,
  });

  factory User.fromJson(Map<String, dynamic> j) {
    return User(
      id: (j['id'] is int) ? j['id'] as int : (j['id'] as num).toInt(),
      username: (j['username'] ?? '') as String,
      nickName: j['nickName'] as String?,
      avatarUrl: j['avatarUrl'] as String?,
      totalRuns: j['totalRuns'] is int ? j['totalRuns'] as int : (j['totalRuns'] as num?)?.toInt(),
      totalDistance: j['totalDistance'] is num ? (j['totalDistance'] as num).toDouble() : null,
      totalDuration: j['totalDuration'] is int ? j['totalDuration'] as int : (j['totalDuration'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'nickName': nickName,
    'avatarUrl': avatarUrl,
    'totalRuns': totalRuns,
    'totalDistance': totalDistance,
    'totalDuration': totalDuration,
  };
}