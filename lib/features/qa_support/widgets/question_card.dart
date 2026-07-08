import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/qna_question.dart';
import '../../../config/routes.dart';

class QuestionCard extends StatelessWidget {
  final QnaQuestion question;
  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, AppRoutes.questionDetail, arguments: question),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.skyBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    question.cropType,
                    style: const TextStyle(color: AppColors.skyBlue, fontWeight: FontWeight.w600, fontSize: 11),
                  ),
                ),
                const Spacer(),
                if (question.resolved)
                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
              ],
            ),
            const SizedBox(height: 10),
            Text(question.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('by ${question.authorName}', style: Theme.of(context).textTheme.bodyMedium),
                const Spacer(),
                const Icon(Icons.forum_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${question.answers.length} answers', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
