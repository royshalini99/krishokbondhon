import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../models/community_post.dart';
import '../../../services/community_service.dart';
import '../widgets/post_card.dart';
import '../../../config/routes.dart';

class CommunityFeedScreen extends StatefulWidget {
  const CommunityFeedScreen({super.key});

  @override
  State<CommunityFeedScreen> createState() => _CommunityFeedScreenState();
}

class _CommunityFeedScreenState extends State<CommunityFeedScreen> {
  final _service = CommunityService.instance;
  final _scrollController = ScrollController();

  List<CommunityPost> _posts = [];
  String? _nextCursor;
  bool _hasMore = true;
  bool _loading = true;
  bool _loadingMore = false;
  String? _error;
  String _filter = 'All';

  final _filters = const ['All', 'Tomato', 'Potato', 'Success Story', 'Pest Control'];

  @override
  void initState() {
    super.initState();
    _loadFeed(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_hasMore || _loadingMore || _loading) return;
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadFeed();
    }
  }

  Future<void> _loadFeed({bool reset = false}) async {
    setState(() {
      if (reset) {
        _loading = true;
        _error = null;
      } else {
        _loadingMore = true;
      }
    });

    try {
      final page = await _service.fetchFeed(
        cursor: reset ? null : _nextCursor,
        tag: _filter,
      );
      setState(() {
        _posts = reset ? page.items : [..._posts, ...page.items];
        _nextCursor = page.nextCursor;
        _hasMore = page.hasMore;
        _loading = false;
        _loadingMore = false;
      });
    } on DioException catch (e) {
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = _friendlyError(e);
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _loadingMore = false;
        _error = 'Something went wrong. Please try again.';
      });
    }
  }

  String _friendlyError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
      return 'No internet connection. Pull down to retry.';
    }
    if (e.response?.statusCode == 401) {
      return 'Your session expired. Please log in again.';
    }
    return 'Could not load the feed right now. Pull down to retry.';
  }

  Future<void> _toggleLike(int index) async {
    final original = _posts[index];
    // Optimistic update
    setState(() {
      _posts[index] = original.copyWith(
        likedByMe: !original.likedByMe,
        likeCount: original.likedByMe ? original.likeCount - 1 : original.likeCount + 1,
      );
    });
    try {
      final result = await _service.toggleLike(original.id);
      if (!mounted) return;
      setState(() {
        _posts[index] = _posts[index].copyWith(likeCount: result.likeCount, likedByMe: result.likedByMe);
      });
    } catch (_) {
      // Roll back on failure.
      if (!mounted) return;
      setState(() => _posts[index] = original);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't update like — check your connection.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farmer Community'),
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = _filters[i];
                final selected = _filter == f;
                return ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  onSelected: (_) {
                    setState(() => _filter = f);
                    _loadFeed(reset: true);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accentAmber,
        onPressed: () async {
          final posted = await Navigator.pushNamed(context, AppRoutes.createPost);
          if (posted == true) _loadFeed(reset: true);
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null && _posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadFeed(reset: true),
        child: ListView(
          children: [
            const SizedBox(height: 80),
            EmptyState(
              icon: Icons.wifi_off_rounded,
              title: 'Unable to load feed',
              message: _error!,
              action: OutlinedButton(onPressed: () => _loadFeed(reset: true), child: const Text('Retry')),
            ),
          ],
        ),
      );
    }
    if (_posts.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _loadFeed(reset: true),
        child: ListView(
          children: const [
            SizedBox(height: 80),
            EmptyState(
              icon: Icons.groups_outlined,
              title: 'No posts yet',
              message: 'Be the first to share something with the community.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadFeed(reset: true),
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
        itemCount: _posts.length + (_hasMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          if (i >= _posts.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          return PostCard(post: _posts[i], onLike: () => _toggleLike(i));
        },
      ),
    );
  }
}
