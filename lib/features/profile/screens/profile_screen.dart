import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../config/routes.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../models/user_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    final displayName = user?.name ?? 'Unknown';
    final locationText = [user?.village, user?.district]
        .where((s) => s != null && s.trim().isNotEmpty)
        .join(', ');
    final crops = user?.crops ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.heroGradient),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(
                        locationText.isEmpty ? 'Location not set' : locationText,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5),
                      ),
                      const SizedBox(height: 8),
                      if (crops.isNotEmpty)
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: crops.map((crop) => _Badge(label: crop)).toList(),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.editProfile, arguments: user),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Note: these three stats aren't wired to real data yet — they'll
          // need their own backend endpoints (diagnosis count, question count,
          // post count) once Phase 4/5/6 are built. Showing 0 for now instead
          // of fake numbers.
          const Row(
            children: [
              Expanded(child: _StatCard(icon: Icons.eco_rounded, value: '0', label: 'Diagnoses')),
              SizedBox(width: 12),
              Expanded(child: _StatCard(icon: Icons.forum_rounded, value: '0', label: 'Questions')),
              SizedBox(width: 12),
              Expanded(child: _StatCard(icon: Icons.groups_rounded, value: '0', label: 'Posts')),
            ],
          ),
          const SizedBox(height: 24),
          _MenuTile(
            icon: Icons.history_rounded,
            label: 'Diagnosis history',
            onTap: () => Navigator.pushNamed(context, AppRoutes.diagnosisHistory),
          ),
          _MenuTile(
            icon: Icons.language_rounded,
            label: 'Language',
            onTap: () => Navigator.pushNamed(context, AppRoutes.language),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
          if (user?.role == UserRole.admin)
            _MenuTile(
              icon: Icons.fact_check_outlined,
              label: 'Pending expert approvals',
              onTap: () => Navigator.pushNamed(context, AppRoutes.adminPendingExperts),
            ),
          _MenuTile(
            icon: Icons.help_outline_rounded,
            label: 'Help & support',
            onTap: () {},
          ),
          _MenuTile(
            icon: Icons.logout_rounded,
            label: 'Log out',
            color: AppColors.danger,
            onTap: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(height: 6),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;
  const _MenuTile({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(icon, color: color ?? AppColors.textPrimary, size: 22),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500))),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}