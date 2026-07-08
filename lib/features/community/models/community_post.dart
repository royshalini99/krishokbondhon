class PostAuthor {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? village;

  const PostAuthor({required this.id, required this.name, this.avatarUrl, this.village});

  factory PostAuthor.fromJson(Map<String, dynamic> json) => PostAuthor(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? 'Unknown',
        avatarUrl: json['avatarUrl'] as String?,
        village: json['village'] as String?,
      );
}

class CommunityPost {
  final String id;
  final PostAuthor author;
  final String content;
  final List<String> images;
  final int likeCount;
  final int commentCount;
  final bool likedByMe;
  final DateTime createdAt;
  final List<String> tags;

  const CommunityPost({
    required this.id,
    required this.author,
    required this.content,
    this.images = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.likedByMe = false,
    required this.createdAt,
    this.tags = const [],
  });

  // Convenience getters so existing widgets (post_card.dart etc.) keep working.
  String get authorName => author.name;
  String? get authorVillage => author.village;

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
        id: json['id'] as String,
        author: PostAuthor.fromJson(json['author'] as Map<String, dynamic>? ?? const {}),
        content: json['content'] as String? ?? '',
        images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? const [],
        likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
        commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
        likedByMe: json['likedByMe'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      );

  CommunityPost copyWith({int? likeCount, bool? likedByMe}) => CommunityPost(
        id: id,
        author: author,
        content: content,
        images: images,
        likeCount: likeCount ?? this.likeCount,
        commentCount: commentCount,
        likedByMe: likedByMe ?? this.likedByMe,
        createdAt: createdAt,
        tags: tags,
      );
}

class PostComment {
  final String id;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const PostComment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) => PostComment(
        id: json['id'] as String,
        authorName: (json['author'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown',
        content: json['content'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}
