import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../services/voice_service.dart';
import '../../../services/qna_service.dart';
import '../../../config/routes.dart';

class AskQuestionScreen extends StatefulWidget {
  const AskQuestionScreen({super.key});

  @override
  State<AskQuestionScreen> createState() => _AskQuestionScreenState();
}

class _AskQuestionScreenState extends State<AskQuestionScreen> {
  final _titleController = TextEditingController();
  String _selectedCrop = 'Tomato';
  bool _listening = false;
  bool _submitting = false;
  String? _error;

  final _crops = const ['Tomato', 'Potato', 'Other'];

  Future<void> _toggleVoiceInput() async {
    if (_listening) {
      await VoiceService.instance.stopListening();
      setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    await VoiceService.instance.startListening(
      onResult: (text) {
        setState(() => _titleController.text = text);
      },
    );
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final question = await QnaService.instance.askQuestion(
        title: _titleController.text.trim(),
        cropType: _selectedCrop,
      );
      if (!mounted) return;
      // Hand off to the detail screen, which polls for the AI answer.
      Navigator.pushReplacementNamed(context, AppRoutes.questionDetail, arguments: question);
    } catch (_) {
      setState(() {
        _submitting = false;
        _error = "Couldn't submit your question. Check your connection and try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask a question')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Which crop is this about?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _crops.map((c) {
                final selected = _selectedCrop == c;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCrop = c),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Text('Your question', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Type your question, or tap the mic to speak in your language...',
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: _toggleVoiceInput,
                  icon: Icon(
                    _listening ? Icons.stop_circle_rounded : Icons.mic_rounded,
                    color: _listening ? AppColors.danger : AppColors.primaryGreen,
                  ),
                  label: Text(_listening ? 'Listening...' : 'Speak'),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: const Text('Add photo'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.danger)),
            ],
            const Spacer(),
            PrimaryButton(label: 'Submit question', isLoading: _submitting, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}
