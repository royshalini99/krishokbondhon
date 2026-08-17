import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../models/community_post.dart';
import '../../../config/routes.dart';
import '../screens/image_gallery_viewer_screen.dart';
import 'translate_language_sheet.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../services/community_service.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback? onLike;
  final VoidCallback? onDeleted;

  const PostCard({super.key, required this.post, this.onLike, this.onDeleted});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Future<void> _handleTranslate(BuildContext context) async {
    final languageCode = await showTranslateLanguageSheet(context);
    if (languageCode == null || !context.mounted) return;

    final languageLabel = kSupportedTranslationLanguages
        .firstWhere((l) => l.code == languageCode)
        .label;

    // Placeholder until the Phase 7 translation service exists.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Translation to $languageLabel will be available soon.')),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete post?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await CommunityService.instance.deletePost(post.id);
      onDeleted?.call();
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't delete the post — check your connection.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, AppRoutes.postDetail, arguments: post),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryGreenLight.withValues(alpha: 0.25),
                  child: Text(
                    post.authorName.isNotEmpty ? post.authorName[0] : '?',
                    style: const TextStyle(color: AppColors.primaryGreenDark, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: Theme.of(context).textTheme.titleMedium),
                      if (post.authorVillage != null)
                        Text(post.authorVillage!, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                Text(_timeAgo(post.createdAt), style: Theme.of(context).textTheme.bodyMedium),
                Builder(
                  builder: (context) {
                    final currentUser = context.watch<AuthProvider>().currentUser;
                    final canDelete = currentUser != null &&
                        (currentUser.id == post.author.id || currentUser.role.name == 'admin');
                    if (!canDelete) return const SizedBox.shrink();
                    return PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, size: 20, color: AppColors.textSecondary),
                      onSelected: (value) {
                        if (value == 'delete') _handleDelete(context);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'delete', child: Text('Delete post')),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge, maxLines: 4, overflow: TextOverflow.ellipsis),

            if (post.images.isNotEmpty) ...[
              const SizedBox(height: 12),
              _PostImageGrid(images: post.images),
            ],

            if (post.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: post.tags
                    .map((t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 11)),
                          visualDensity: VisualDensity.compact,
                          padding: EdgeInsets.zero,
                        ))
                    .toList(),
              ),
            ],

            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _handleTranslate(context),
                icon: const Icon(Icons.translate_rounded, size: 16),
                label: const Text('Translate', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),

            const SizedBox(height: 6),
            Row(
              children: [
                InkWell(
                  onTap: onLike,
                  child: Row(
                    children: [
                      Icon(
                        post.likedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        size: 20,
                        color: post.likedByMe ? AppColors.danger : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text('${post.likeCount}', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.mode_comment_outlined, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('${post.commentCount}', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a post's images in a grid — single full-width photo for one
/// image, otherwise a 2-column grid. Tapping any tile opens the
/// full-screen, pinch-to-zoom gallery starting at that photo.
class _PostImageGrid extends StatelessWidget {
  final List<String> images;
  const _PostImageGrid({required this.images});

  void _open(BuildContext context, int index) {
    final urls = images.map(ApiConstants.resolveImageUrl).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImageGalleryViewerScreen(imageUrls: urls, initialIndex: index),
      ),
    );
  }

  Widget _tile(BuildContext context, int index) {
    final url = ApiConstants.resolveImageUrl(images[index]);
    return GestureDetector(
      onTap: () => _open(context, index),
      child: Image.network(
        url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.surfaceMuted,
            child: const Center(
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.surfaceMuted,
          child: const Center(
            child: Icon(Icons.broken_image_outlined, color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: _tile(context, 0),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, i) => _tile(context, i),
      ),
    );
  }
}