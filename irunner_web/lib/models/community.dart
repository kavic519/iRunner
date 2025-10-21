class Community {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int? memberCount;
  bool? isJoined;
  final int? creatorId;

  Community({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.memberCount,
    this.isJoined,
    this.creatorId,
  });

  factory Community.fromJson(Map<String, dynamic> j) {
    return Community(
      id: (j['id'] is int) ? j['id'] as int : (j['id'] as num).toInt(),
      name: (j['name'] ?? '') as String,
      description: j['description'] as String?,
      imageUrl: j['imageUrl'] as String?,
      memberCount: j['memberCount'] is int ? j['memberCount'] as int : (j['memberCount'] as num?)?.toInt(),
      isJoined: j['isJoined'] == null ? null : (j['isJoined'] == true),
      creatorId: j['creatorId'] is int
          ? j['creatorId'] as int
          : int.tryParse(j['creatorId']?.toString() ?? ''),
    );
  }
}