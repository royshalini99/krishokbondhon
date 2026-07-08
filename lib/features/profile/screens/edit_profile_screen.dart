import 'package:flutter/material.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  final AppUser? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _nameController = TextEditingController(text: widget.user?.name ?? 'Ratul Deb');
  late final _villageController = TextEditingController(text: widget.user?.village ?? 'Katigorah');
  late final _districtController = TextEditingController(text: widget.user?.district ?? 'Cachar');
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 28),
            PrimaryButton(label: 'Save changes', isLoading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }
}
