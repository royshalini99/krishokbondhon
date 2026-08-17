import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'api_service.dart';
import '../features/community/models/community_post.dart';
import '../models/paginated.dart';

class CommunityService {
  CommunityService._();
  static final CommunityService instance = CommunityService._();

  final _api = ApiService.instance;

  Future<Paginated<CommunityPost>> fetchFeed({String? cursor, String? tag, int limit = 20}) async {
    final response = await _api.get(
      ApiConstants.feed,
      query: {
        if (cursor != null) 'cursor': cursor,
        if (tag != null && tag != 'All') 'tag': tag,
        'limit': limit,
      },
    );
    return Paginated.fromJson(
      response.data as Map<String, dynamic>,
      (json) => CommunityPost.fromJson(json),
    );
  }

  Future<CommunityPost> createPost({
    required String content,
    required List<String> tags,
    List<String> imagePaths = const [],
  }) async {
    // Built manually (NOT FormData.fromMap) because a Dart Map can only
    // hold one value per key — repeating 'images[]' in a map literal
    // silently overwrites all but the last file. form.fields/.files are
    // lists of MapEntry, so duplicate field names are preserved correctly.
    final form = FormData();
    form.fields.add(MapEntry('content', content));
    for (final tag in tags) {
      form.fields.add(MapEntry('tags', tag));
    }
    for (final path in imagePaths) {
      form.files.add(MapEntry('images[]', await MultipartFile.fromFile(path)));
    }

    final response = await _api.post(ApiConstants.createPost, data: form);
    return CommunityPost.fromJson(response.data as Map<String, dynamic>);
  }

  Future<({int likeCount, bool likedByMe})> toggleLike(String postId) async {
    final response = await _api.post(ApiConstants.withId(ApiConstants.likePost, postId));
    final data = response.data as Map<String, dynamic>;
    return (likeCount: data['likeCount'] as int, likedByMe: data['likedByMe'] as bool);
  }

  Future<Paginated<PostComment>> fetchComments(String postId, {String? cursor, int limit = 20}) async {
    final response = await _api.get(
      ApiConstants.withId(ApiConstants.postComments, postId),
      query: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    return Paginated.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PostComment.fromJson(json),
    );
  }

  Future<PostComment> addComment(String postId, String content) async {
    final response = await _api.post(
      ApiConstants.withId(ApiConstants.postComments, postId),
      data: {'content': content},
    );
    return PostComment.fromJson(response.data as Map<String, dynamic>);
  }
  
  Future<void> deletePost(String postId) async {
    await _api.delete(ApiConstants.withId(ApiConstants.deletePost, postId));
  }
}