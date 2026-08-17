import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../config/routes.dart';
import '../providers/auth_provider.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isExpert;
  const OtpScreen({super.key, required this.phone, this.isExpert = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _loading = false;
  int _secondsLeft = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _verify() async {
    setState(() => _loading = true);

    final error = await context.read<AuthProvider>().verifyOtp(
          phone: widget.phone,
          otp: _otpController.text.trim(),
        );

    setState(() => _loading = false);
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    if (widget.isExpert) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.expertSignup, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.main, (route) => false);
    }
  }

  Future<void> _resend() async {
    final error = await context.read<AuthProvider>().sendOtp(phone: widget.phone);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('OTP resent.')));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Verify your number', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to +91 ${widget.phone}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(14),
                  fieldHeight: 52,
                  fieldWidth: 44,
                  activeColor: AppColors.primaryGreen,
                  selectedColor: AppColors.primaryGreen,
                  inactiveColor: AppColors.divider,
                  activeFillColor: AppColors.surfaceMuted,
                  inactiveFillColor: AppColors.surfaceMuted,
                  selectedFillColor: AppColors.surfaceMuted,
                ),
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              Center(
                child: _secondsLeft > 0
                    ? Text('Resend code in ${_secondsLeft}s', style: Theme.of(context).textTheme.bodyMedium)
                    : TextButton(
                        onPressed: _resend,
                        child: const Text('Resend OTP'),
                      ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(label: 'Verify & Continue', isLoading: _loading, onPressed: _verify),
            ],
          ),
        ),
      ),
    );
  }
}