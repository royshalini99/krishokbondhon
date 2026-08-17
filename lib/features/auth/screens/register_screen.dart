import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../config/routes.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _villageController = TextEditingController();
  final _districtController = TextEditingController();
  final _stateController = TextEditingController();
  String _selectedCrop = 'Tomato';
  String _selectedRole = 'farmer'; // 'farmer' or 'expert'
  bool _loading = false;

  final _crops = const ['Tomato', 'Potato', 'Both'];

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final crops = _selectedCrop == 'Both' ? ['Tomato', 'Potato'] : [_selectedCrop];
    final phone = _phoneController.text.trim();

    final error = await context.read<AuthProvider>().register(
          name: _nameController.text.trim(),
          phone: phone,
          village: _villageController.text.trim(),
          district: _districtController.text.trim(),
          state: _stateController.text.trim(),
          crops: crops,
          role: _selectedRole,
        );

    setState(() => _loading = false);
    if (!mounted) return;

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.otp,
      arguments: {'phone': phone, 'isExpert': _selectedRole == 'expert'},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tell us about yourself', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 6),
                Text(
                  'This helps us tailor advisory content to your farm.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text('I am a', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: [
                    ChoiceChip(
                      label: const Text('Farmer'),
                      selected: _selectedRole == 'farmer',
                      onSelected: (_) => setState(() => _selectedRole = 'farmer'),
                    ),
                    ChoiceChip(
                      label: const Text('Agricultural Expert'),
                      selected: _selectedRole == 'expert',
                      onSelected: (_) => setState(() => _selectedRole = 'expert'),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Full name',
                  hint: 'e.g. Ratul Deb',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Mobile number',
                  hint: '9xxxxxxxxx',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_iphone_rounded,
                  validator: (v) {
                    if (v == null || v.trim().length < 10) {
                      return 'Enter a valid 10-digit mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'Village',
                  hint: 'e.g. Katigorah',
                  controller: _villageController,
                  prefixIcon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'District',
                  hint: 'e.g. Cachar',
                  controller: _districtController,
                  prefixIcon: Icons.map_outlined,
                ),
                const SizedBox(height: 18),
                AppTextField(
                  label: 'State',
                  hint: 'e.g. Assam',
                  controller: _stateController,
                  prefixIcon: Icons.public_outlined,
                ),
                const SizedBox(height: 18),
                Text('Primary crop', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: _crops.map((crop) {
                    final selected = _selectedCrop == crop;
                    return ChoiceChip(
                      label: Text(crop),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedCrop = crop),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  label: 'Continue',
                  isLoading: _loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}