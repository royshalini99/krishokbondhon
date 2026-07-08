import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/expert_model.dart';

class ExpertProfileScreen extends StatelessWidget {
  final dynamic expert;
  const ExpertProfileScreen({super.key, required this.expert});

  @override
  Widget build(BuildContext context) {
    final e = expert as Expert;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primaryGreenLight.withValues(alpha: 0.2),
              child: Text(e.name[0], style: const TextStyle(fontSize: 32, color: AppColors.primaryGreenDark, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(e.name, style: Theme.of(context).textTheme.headlineMedium),
                if (e.verified) const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.verified_rounded, color: AppColors.primaryGreen),
                ),
              ],
            ),
            Text(e.designation, style: Theme.of(context).textTheme.bodyMedium),
            Text(e.institution, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(label: 'Rating', value: '${e.rating}', icon: Icons.star_rounded),
                _Stat(label: 'Answers', value: '${e.questionsAnswered}', icon: Icons.forum_rounded),
                _Stat(label: 'Status', value: e.online ? 'Online' : 'Offline', icon: Icons.circle, iconColor: e.online ? AppColors.success : AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Specialization', style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: e.specialization.map<Widget>((s) => Chip(label: Text(s))).toList(),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Languages', style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: e.languages.map<Widget>((l) => Chip(
                    label: Text(l),
                    avatar: const Icon(Icons.language_rounded, size: 16),
                  )).toList(),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              label: 'Ask this expert a question',
              icon: Icons.forum_rounded,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  const _Stat({required this.label, required this.value, required this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.accentAmberDark, size: 20),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
