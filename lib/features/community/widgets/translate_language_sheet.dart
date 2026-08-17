import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TranslateLanguageOption {
  final String code;
  final String label;
  const TranslateLanguageOption(this.code, this.label);
}

const kSupportedTranslationLanguages = [
  TranslateLanguageOption('en', 'English'),
  TranslateLanguageOption('as', 'Assamese'),
  TranslateLanguageOption('hi', 'Hindi'),
  TranslateLanguageOption('bn', 'Bengali'),
  TranslateLanguageOption('kha', 'Khasi'),
  TranslateLanguageOption('grt', 'Garo'),
  TranslateLanguageOption('lus', 'Mizo'),
  TranslateLanguageOption('mni', 'Manipuri'),
];

/// Bottom sheet letting the farmer pick a language to translate a post
/// into. Returns the chosen language code, or null if dismissed.
Future<String?> showTranslateLanguageSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true, // lets the sheet grow, and lets us cap its height below
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      // Cap the sheet at 70% of screen height — if content is taller than
      // that (e.g. more languages added later), the ListView below scrolls
      // instead of overflowing off the bottom of the screen.
      final maxHeight = MediaQuery.of(context).size.height * 0.7;

      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.translate_rounded, color: AppColors.primaryGreen),
                    const SizedBox(width: 10),
                    Text('Translate to', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: kSupportedTranslationLanguages.length,
                  itemBuilder: (context, i) {
                    final lang = kSupportedTranslationLanguages[i];
                    return ListTile(
                      title: Text(lang.label),
                      onTap: () => Navigator.pop(context, lang.code),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    },
  );
}