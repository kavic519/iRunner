class Achievement {
  final int id;
  final String code;
  final String name;
  final String? description;
  final bool isUnlocked;
  final double? progress; // 0.0 - 1.0

  Achievement({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.isUnlocked,
    this.progress,
  });

  factory Achievement.fromJson(Map<String, dynamic> j) {
    return Achievement(
      id: (j['id'] is int) ? j['id'] as int : (j['id'] as num).toInt(),
      code: (j['code'] ?? '') as String,
      name: (j['name'] ?? '') as String,
      description: j['description'] as String?,
      isUnlocked: j['isUnlocked'] == true,
      progress: j['progress'] is num ? (j['progress'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'isUnlocked': isUnlocked,
    'progress': progress,
  };
}