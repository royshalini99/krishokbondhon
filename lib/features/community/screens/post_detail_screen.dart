import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/community_post.dart';
import '../widgets/post_card.dart';
import '../../../services/community_service.dart';

class PostDetailScreen extends StatefulWidget {
  final dynamic post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentController = TextEditingController();
  final _service = CommunityService.instance;

  List<PostComment> _comments = [];
  bool _loading = true;
  bool _sending = false;
  String? _error;

  late CommunityPost _post;

  @override
  void initState() {
    super.initState();
    _post = widget.post as CommunityPost;
    _loadComments();
  }

  Future<void> _loadComments() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _service.fetchComments(_post.id);
      setState(() {
        _comments = page.items;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = "Couldn't load comments. Pull down to retry.";
      });
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final comment = await _service.addComment(_post.id, text);
      setState(() {
        _comments = [..._comments, comment];
        _commentController.clear();
        _sending = false;
      });
    } catch (_) {
      setState(() => _sending = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't post your comment — check your connection.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post')),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadComments,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  PostCard(post: _post),
                  const SizedBox(height: 20),
                  Text('Comments (${_comments.length})', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (_loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(_error!, style: const TextStyle(color: AppColors.danger)),
                    )
                  else if (_comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text('No comments yet — be the first to reply.', style: Theme.of(context).textTheme.bodyMedium),
                    )
                  else
                    ..._comments.map((c) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.surfaceMuted,
                                child: Text(c.authorName.isNotEmpty ? c.authorName[0] : '?',
                                    style: const TextStyle(color: AppColors.primaryGreen)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceMuted,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c.authorName, style: Theme.of(context).textTheme.titleMedium),
                                      const SizedBox(height: 4),
                                      Text(c.content, style: Theme.of(context).textTheme.bodyLarge),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(hintText: 'Write a comment...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sending ? null : _addComment,
                    icon: _sending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
