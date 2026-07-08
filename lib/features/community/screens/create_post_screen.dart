import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/community_service.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _contentController = TextEditingController();
  final _tags = <String>{};
  final _availableTags = const ['Tomato', 'Potato', 'Pest Control', 'Success Story', 'Question'];
  final _picker = ImagePicker();
  XFile? _image;
  bool _posting = false;
  String? _error;

  Future<void> _pickImage() async {
    final file = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (file != null) setState(() => _image = file);
  }

  Future<void> _submit() async {
    if (_contentController.text.trim().isEmpty) return;
    setState(() {
      _posting = true;
      _error = null;
    });
    try {
      await CommunityService.instance.createPost(
        content: _contentController.text.trim(),
        tags: _tags.toList(),
        imagePaths: _image != null ? [_image!.path] : const [],
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      setState(() {
        _posting = false;
        _error = "Couldn't publish your post. Check your connection and try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share with community')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _contentController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: "What's happening on your farm today?",
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(File(_image!.path), height: 160, width: double.infinity, fit: BoxFit.cover),
                      )
                    else
                      OutlinedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: const Text('Add photo'),
                      ),
                    const SizedBox(height: 20),
                    Text('Tag your post', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableTags.map((tag) {
                        final selected = _tags.contains(tag);
                        return FilterChip(
                          label: Text(tag),
                          selected: selected,
                          selectedColor: AppColors.primaryGreen.withValues(alpha: 0.15),
                          onSelected: (v) => setState(() => v ? _tags.add(tag) : _tags.remove(tag)),
                        );
                      }).toList(),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(_error!, style: const TextStyle(color: AppColors.danger)),
                    ],
                  ],
                ),
              ),
            ),
            PrimaryButton(label: 'Post', isLoading: _posting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
