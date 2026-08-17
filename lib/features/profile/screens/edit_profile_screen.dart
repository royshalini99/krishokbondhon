import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../models/user_model.dart';
import '../../auth/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late AppUser? _user;
  late final TextEditingController _nameController;
  late final TextEditingController _villageController;
  late final TextEditingController _districtController;
  late final TextEditingController _stateController;
  late final TextEditingController _emailController;
  final _otpController = TextEditingController();

  static const _availableCrops = ['Tomato', 'Potato', 'Rice', 'Maize', 'Chili', 'Ginger'];
  late Set<String> _selectedCrops;

  bool _saving = false;
  bool _sendingEmailOtp = false;
  bool _verifyingEmailOtp = false;
  bool _emailOtpSent = false;
  String? _errorMessage;
  String? _verifiedEmailSnapshot;

  @override
  void initState() {
    super.initState();
    _user = widget.user ?? context.read<AuthProvider>().currentUser;

    _nameController = TextEditingController(text: _user?.name ?? '');
    _villageController = TextEditingController(text: _user?.village ?? '');
    _districtController = TextEditingController(text: _user?.district ?? '');
    _stateController = TextEditingController(text: _user?.state ?? '');
    _emailController = TextEditingController(text: _user?.email ?? '');
    _selectedCrops = Set<String>.from(_user?.crops ?? const []);

    _verifiedEmailSnapshot = (_user?.isEmailVerified ?? false) ? _user?.email : null;

    _emailController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _nameController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  bool get _emailDiffersFromVerified {
    final typed = _emailController.text.trim();
    if (typed.isEmpty) return false;
    return typed != (_verifiedEmailSnapshot ?? '');
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _errorMessage = null;
    });

    final error = await context.read<AuthProvider>().updateProfile(
          village: _villageController.text.trim(),
          district: _districtController.text.trim(),
          state: _stateController.text.trim(),
          crops: _selectedCrops.toList(),
        );

    setState(() => _saving = false);
    if (!mounted) return;

    if (error != null) {
      setState(() => _errorMessage = error);
      return;
    }

    Navigator.pop(context, true);
  }

  Future<void> _sendEmailCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Enter an email address first.');
      return;
    }

    setState(() {
      _sendingEmailOtp = true;
      _errorMessage = null;
    });

    final error = await context.read<AuthProvider>().sendEmailOtp(email: email);

    setState(() {
      _sendingEmailOtp = false;
      if (error == null) {
        _emailOtpSent = true;
      } else {
        _errorMessage = error;
      }
    });
  }

  Future<void> _verifyEmailCode() async {
    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      setState(() => _errorMessage = 'Enter the code sent to your email.');
      return;
    }

    setState(() {
      _verifyingEmailOtp = true;
      _errorMessage = null;
    });

    final error = await context.read<AuthProvider>().verifyEmailOtp(email: email, otp: otp);

    setState(() {
      _verifyingEmailOtp = false;
      if (error == null) {
        _emailOtpSent = false;
        _otpController.clear();
        _verifiedEmailSnapshot = email;
      } else {
        _errorMessage = error;
      }
    });

    if (error == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email verified successfully.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthProvider>().currentUser;

    final showVerifiedBadge = !_emailDiffersFromVerified &&
        _verifiedEmailSnapshot != null &&
        _verifiedEmailSnapshot == currentUser?.email &&
        (currentUser?.isEmailVerified ?? false);

    final showUnverifiedLabel =
        _emailController.text.trim().isNotEmpty && !showVerifiedBadge && !_emailOtpSent;

    final showSendCodeButton = _emailDiffersFromVerified && !_emailOtpSent;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(label: 'Full name', controller: _nameController, prefixIcon: Icons.person_outline_rounded),
            const SizedBox(height: 16),
            AppTextField(label: 'Village', controller: _villageController, prefixIcon: Icons.location_on_outlined),
            const SizedBox(height: 16),
            AppTextField(label: 'District', controller: _districtController, prefixIcon: Icons.map_outlined),
            const SizedBox(height: 16),
            AppTextField(label: 'State', controller: _stateController, prefixIcon: Icons.public_outlined),
            const SizedBox(height: 24),

            Text('Crops grown', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Select all that apply.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: _availableCrops.map((crop) {
                final selected = _selectedCrops.contains(crop);
                return FilterChip(
                  label: Text(crop),
                  selected: selected,
                  onSelected: (isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedCrops.add(crop);
                      } else {
                        _selectedCrops.remove(crop);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                Text('Email', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                if (showVerifiedBadge)
                  const Icon(Icons.verified_rounded, color: Colors.green, size: 18)
                else if (showUnverifiedLabel)
                  const Text('(unverified)', style: TextStyle(color: Colors.orange, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Optional — add an email to receive updates. You can use the app fully without one.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            AppTextField(
              label: 'Email address',
              hint: 'you@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 10),

            if (showSendCodeButton)
              OutlinedButton(
                onPressed: _sendingEmailOtp ? null : _sendEmailCode,
                child: _sendingEmailOtp
                    ? const SizedBox(
                        width: 18, height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send verification code'),
              ),

            if (_emailOtpSent) ...[
              AppTextField(
                label: 'Verification code',
                hint: '6-digit code',
                controller: _otpController,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.lock_outline_rounded,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _verifyingEmailOtp ? null : _verifyEmailCode,
                      child: _verifyingEmailOtp
                          ? const SizedBox(
                              width: 18, height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Verify code'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: _sendingEmailOtp ? null : _sendEmailCode,
                    child: const Text('Resend'),
                  ),
                ],
              ),
            ],

            if (_errorMessage != null) ...[
              const SizedBox(height: 14),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],

            const SizedBox(height: 28),
            PrimaryButton(label: 'Save changes', isLoading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}