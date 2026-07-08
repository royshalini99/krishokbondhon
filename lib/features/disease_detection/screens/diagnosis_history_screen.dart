import 'package:flutter/material.dart';
import '../../../core/widgets/section_header.dart';
import '../../../services/mock_data_service.dart';
import '../widgets/diagnosis_history_card.dart';

class DiagnosisHistoryScreen extends StatelessWidget {
  const DiagnosisHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockDataService.diagnosisHistory();
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnosis history')),
      body: items.isEmpty
          ? const EmptyState(
              icon: Icons.eco_outlined,
              title: 'No diagnoses yet',
              message: 'Scan a leaf to see your detection history here.',
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.86,
              ),
              itemBuilder: (context, i) => DiagnosisHistoryCard(result: items[i]),
            ),
    );
  }
}
