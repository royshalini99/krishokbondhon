import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/mock_data_service.dart';
import '../../../config/routes.dart';

class ExpertListScreen extends StatelessWidget {
  const ExpertListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final experts = MockDataService.experts();

    return Scaffold(
      appBar: AppBar(title: const Text('Agriculture Experts')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: experts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final e = experts[i];
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(context, AppRoutes.expertProfile, arguments: e),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryGreenLight.withValues(alpha: 0.2),
                        child: Text(e.name[0], style: const TextStyle(color: AppColors.primaryGreenDark, fontSize: 20, fontWeight: FontWeight.w700)),
                      ),
                      if (e.online)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(e.name, style: Theme.of(context).textTheme.titleMedium)),
                            if (e.verified) const Icon(Icons.verified_rounded, size: 16, color: AppColors.primaryGreen),
                          ],
                        ),
                        Text(e.designation, style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppColors.accentAmberDark),
                            const SizedBox(width: 2),
                            Text('${e.rating}', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(width: 10),
                            Text('${e.questionsAnswered} answers', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
