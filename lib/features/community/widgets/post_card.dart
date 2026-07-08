import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/community_post.dart';
import '../../../config/routes.dart';

class PostCard extends StatelessWidget {
  final CommunityPost post;
  final VoidCallback? onLike;

  const PostCard({super.key, required this.post, this.onLike});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
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
              ],
            ),
            const SizedBox(height: 12),
            Text(post.content, style: Theme.of(context).textTheme.bodyLarge, maxLines: 4, overflow: TextOverflow.ellipsis),
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
            const SizedBox(height: 10),
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
