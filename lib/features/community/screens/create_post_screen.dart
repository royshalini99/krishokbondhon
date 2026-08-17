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
  static const _maxImages = 4;

  final _contentController = TextEditingController();
  final _tags = <String>{};
  final _availableTags = const ['Tomato', 'Potato', 'Pest Control', 'Success Story', 'Question'];
  final _picker = ImagePicker();
  final List<XFile> _images = [];
  bool _posting = false;
  String? _error;

  Future<void> _pickImages() async {
    final remaining = _maxImages - _images.length;
    if (remaining <= 0) {
      setState(() => _error = 'You can add up to $_maxImages photos per post.');
      return;
    }

    final files = await _picker.pickMultiImage(imageQuality: 85, limit: remaining);
    if (files.isEmpty) return;

    setState(() {
      _images.addAll(files.take(remaining));
      _error = null;
    });
  }

  void _removeImage(int index) {
    setState(() => _images.removeAt(index));
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
        imagePaths: _images.map((f) => f.path).toList(),
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
                      maxLength: 2000,
                      decoration: const InputDecoration(
                        hintText: "What's happening on your farm today?",
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (_images.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, i) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.file(
                                    File(_images[i].path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(i),
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 12),
                    if (_images.length < _maxImages)
                      OutlinedButton.icon(
                        onPressed: _pickImages,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                        label: Text(_images.isEmpty
                            ? 'Add photos'
                            : 'Add more (${_images.length}/$_maxImages)'),
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