import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../providers/app_state_provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose your language')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: AppStrings.supportedLocales.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final entry = AppStrings.supportedLocales.entries.elementAt(i);
          final selected = appState.localeCode == entry.key;
          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.read<AppStateProvider>().setLocale(entry.key),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: selected ? AppColors.primaryGreen.withValues(alpha: 0.08) : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.divider, width: selected ? 1.5 : 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(entry.value, style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
