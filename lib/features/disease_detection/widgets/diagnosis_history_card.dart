import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/disease_result.dart';
import '../../../config/routes.dart';

Color severityColor(DiseaseSeverity s) {
  switch (s) {
    case DiseaseSeverity.healthy:
      return AppColors.severityHealthy;
    case DiseaseSeverity.mild:
      return AppColors.severityMild;
    case DiseaseSeverity.moderate:
      return AppColors.severityModerate;
    case DiseaseSeverity.severe:
      return AppColors.severitySevere;
  }
}

String severityLabel(DiseaseSeverity s) {
  switch (s) {
    case DiseaseSeverity.healthy:
      return 'Healthy';
    case DiseaseSeverity.mild:
      return 'Mild';
    case DiseaseSeverity.moderate:
      return 'Moderate';
    case DiseaseSeverity.severe:
      return 'Severe';
  }
}

class DiagnosisHistoryCard extends StatelessWidget {
  final DiseaseResult result;
  const DiagnosisHistoryCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => Navigator.pushNamed(context, AppRoutes.diagnosisResult, arguments: result),
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
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.eco_outlined, color: AppColors.primaryGreen, size: 20),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: severityColor(result.severity).withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    severityLabel(result.severity),
                    style: TextStyle(
                      color: severityColor(result.severity),
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              result.diseaseName,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text('${result.cropType} · ${(result.confidence * 100).toStringAsFixed(0)}% confidence',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
