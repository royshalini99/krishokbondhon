import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../config/routes.dart';
import '../../../core/constants/app_colors.dart';

/// Shown briefly on app startup while we check whether a saved login
/// token still works. Routes to Home if valid, Login if not.
class SessionCheckScreen extends StatefulWidget {
  const SessionCheckScreen({super.key});

  @override
  State<SessionCheckScreen> createState() => _SessionCheckScreenState();
}

class _SessionCheckScreenState extends State<SessionCheckScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkSavedSession();
    if (!mounted) return;

    if (authProvider.currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppColors.heroGradient),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 34),
        ),
      ),
    );
  }
}