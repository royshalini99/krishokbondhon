import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../config/routes.dart';
import '../../auth/providers/auth_provider.dart';

/// Shown right after OTP verification for users who signed up as
/// "Agricultural Expert" — collects credentials for admin review.
class ExpertSignupScreen extends StatefulWidget {
  const ExpertSignupScreen({super.key});

  @override
  State<ExpertSignupScreen> createState() => _ExpertSignupScreenState();
}

class _ExpertSignupScreenState extends State<ExpertSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _institutionController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _credentialsLinkController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    final error = await context.read<AuthProvider>().submitExpertProfile(
          institution: _institutionController.text.trim(),
          specialty: _specialtyController.text.trim(),
          credentialsDocUrl: _credentialsLinkController.text.trim().isEmpty
              ? null
              : _credentialsLinkController.text.trim(),
        );

    setState(() => _loading = false);
    if (!mounted) return;

    if (error != null) {
      setState(() => _errorMessage = error);
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Submitted! An admin will review your expert profile soon.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expert profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('A few more details', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'This helps us verify you as an agricultural expert before you can answer farmer questions.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Institution',
                  hint: 'e.g. Assam Agricultural University',
                  controller: _institutionController,
                  prefixIcon: Icons.school_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Institution is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Specialty',
                  hint: 'e.g. Plant Pathology',
                  controller: _specialtyController,
                  prefixIcon: Icons.eco_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Specialty is required' : null,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Credentials link (optional)',
                  hint: 'Link to a certificate or ID, if available',
                  controller: _credentialsLinkController,
                  prefixIcon: Icons.link_outlined,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 28),
                PrimaryButton(label: 'Submit for review', isLoading: _loading, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}