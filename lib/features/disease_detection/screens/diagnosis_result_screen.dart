import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/disease_result.dart';
import '../widgets/diagnosis_history_card.dart';
import '../../../config/routes.dart';

class DiagnosisResultScreen extends StatelessWidget {
  final dynamic result;
  const DiagnosisResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final r = result as DiseaseResult;

    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.image_rounded, size: 48, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: severityColor(r.severity).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    severityLabel(r.severity),
                    style: TextStyle(color: severityColor(r.severity), fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 10),
                Text('${r.cropType} crop', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 10),
            Text(r.diseaseName, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.verified_rounded, size: 16, color: AppColors.primaryGreen),
                const SizedBox(width: 6),
                Text(
                  '${(r.confidence * 100).toStringAsFixed(1)}% AI confidence',
                  style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('About this disease', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(r.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 24),
            Text('Recommended remedies', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...r.remedies.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${e.key + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(e.value, style: Theme.of(context).textTheme.bodyLarge)),
                      ],
                    ),
                  ),
                ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.askQuestion),
                    icon: const Icon(Icons.forum_outlined),
                    label: const Text('Ask an expert'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PrimaryButton(
              label: 'Done',
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }
}
