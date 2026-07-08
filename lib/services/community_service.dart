import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import 'api_service.dart';
import '../features/community/models/community_post.dart';
import '../models/paginated.dart';

/// Talks to the `/community/*` endpoints on the Node.js gateway.
/// See docs/API_CONTRACT.md for the exact request/response shapes.
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
    final form = FormData.fromMap({
      'content': content,
      'tags': tags, // Dio serializes List<String> as repeated form fields
      for (var i = 0; i < imagePaths.length; i++)
        'images[]': await MultipartFile.fromFile(imagePaths[i]),
    });
    final response = await _api.post(ApiConstants.createPost, data: form);
    return CommunityPost.fromJson(response.data as Map<String, dynamic>);
  }

  /// Returns the authoritative like count + state from the server so the
  /// UI can reconcile if a double-tap raced with the request.
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
}
