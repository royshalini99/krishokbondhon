import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/mock_data_service.dart';
import '../../../config/routes.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  final _picker = ImagePicker();
  XFile? _picked;
  bool _analyzing = false;

  Future<void> _pick(ImageSource source) async {
    final file = await _picker.pickImage(source: source, imageQuality: 85);
    if (file != null) setState(() => _picked = file);
  }

  Future<void> _analyze() async {
    setState(() => _analyzing = true);
    // TODO: replace with real call to the FastAPI disease-detection microservice
    // via ApiService.instance.post(ApiConstants.diagnoseCrop, data: formData)
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _analyzing = false);
    if (!mounted) return;
    final result = MockDataService.diagnosisHistory().first;
    Navigator.pushReplacementNamed(context, AppRoutes.diagnosisResult, arguments: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detect crop disease')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.divider),
                ),
                clipBehavior: Clip.antiAlias,
                child: _picked == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.image_search_rounded, size: 56, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          Text(
                            'Take or upload a clear photo\nof the affected leaf',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      )
                    : Image.file(File(_picked!.path), fit: BoxFit.cover, width: double.infinity),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_rounded),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_rounded),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Analyze photo',
              isLoading: _analyzing,
              onPressed: _picked == null ? null : _analyze,
            ),
          ],
        ),
      ),
    );
  }
}
