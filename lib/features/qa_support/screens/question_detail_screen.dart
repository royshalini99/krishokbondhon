import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/qna_question.dart';
import '../../../services/voice_service.dart';
import '../../../services/qna_service.dart';

class QuestionDetailScreen extends StatefulWidget {
  final dynamic question;
  const QuestionDetailScreen({super.key, required this.question});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final _replyController = TextEditingController();
  final _service = QnaService.instance;

  late QnaQuestion _question;
  StreamSubscription<QnaQuestion>? _watchSub;
  bool _sendingReply = false;

  @override
  void initState() {
    super.initState();
    _question = widget.question as QnaQuestion;
    if (_question.status == QuestionStatus.pending) {
      _startWatching();
    }
  }

  void _startWatching() {
    _watchSub = _service.watchQuestion(_question.id).listen(
      (updated) {
        if (!mounted) return;
        setState(() => _question = updated);
      },
      onError: (_) {
        // Polling failure is non-fatal — the farmer can still pull-to-refresh
        // manually, and their submitted question is already saved server-side.
      },
    );
  }

  Future<void> _refresh() async {
    try {
      final updated = await _service.fetchQuestion(_question.id);
      if (!mounted) return;
      setState(() => _question = updated);
      if (updated.status == QuestionStatus.pending && _watchSub == null) {
        _startWatching();
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't refresh — check your connection.")),
      );
    }
  }

  Future<void> _sendReply() async {
    final text = _replyController.text.trim();
    if (text.isEmpty || _sendingReply) return;
    setState(() => _sendingReply = true);
    try {
      final answer = await _service.addAnswer(_question.id, text);
      if (!mounted) return;
      setState(() {
        _question = _question.copyWith(
          answers: [..._question.answers, answer],
          status: QuestionStatus.answered,
        );
        _replyController.clear();
        _sendingReply = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _sendingReply = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't post your answer — check your connection.")),
      );
    }
  }

  @override
  void dispose() {
    _watchSub?.cancel();
    super.dispose();
  }

  IconData _sourceIcon(AnswerSource s) {
    switch (s) {
      case AnswerSource.ai:
        return Icons.smart_toy_rounded;
      case AnswerSource.expert:
        return Icons.verified_rounded;
      case AnswerSource.farmer:
        return Icons.person_rounded;
    }
  }

  Color _sourceColor(AnswerSource s) {
    switch (s) {
      case AnswerSource.ai:
        return AppColors.skyBlue;
      case AnswerSource.expert:
        return AppColors.primaryGreen;
      case AnswerSource.farmer:
        return AppColors.accentAmberDark;
    }
  }

  String _sourceLabel(AnswerSource s) {
    switch (s) {
      case AnswerSource.ai:
        return 'AI Assistant';
      case AnswerSource.expert:
        return 'Verified Expert';
      case AnswerSource.farmer:
        return 'Fellow Farmer';
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _question;

    return Scaffold(
      appBar: AppBar(title: const Text('Question')),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(q.cropType, style: const TextStyle(fontSize: 11)),
                              visualDensity: VisualDensity.compact,
                            ),
                            const Spacer(),
                            Text('by ${q.authorName}', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(q.title, style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (q.status == QuestionStatus.pending && !q.hasAiAnswer) _PendingAiCard(),
                  Text('${q.answers.length} Answers', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  ...q.answers.map((a) => Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _sourceColor(a.source).withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(_sourceIcon(a.source), size: 16, color: _sourceColor(a.source)),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(a.authorName, style: Theme.of(context).textTheme.titleMedium),
                                      Text(_sourceLabel(a.source),
                                          style: TextStyle(color: _sourceColor(a.source), fontSize: 11, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.volume_up_rounded, size: 20),
                                  onPressed: () => VoiceService.instance.speak(a.content),
                                  tooltip: 'Listen',
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(a.content, style: Theme.of(context).textTheme.bodyLarge),
                            if (a.verified) ...[
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, size: 14, color: AppColors.success),
                                  SizedBox(width: 4),
                                  Text('Verified by expert', style: TextStyle(fontSize: 11.5, color: AppColors.success)),
                                ],
                              ),
                            ],
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(hintText: 'Add your own answer...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _sendingReply ? null : _sendReply,
                    icon: _sendingReply
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.send_rounded),
                    style: IconButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingAiCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.skyBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.skyBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: AppColors.skyBlue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'KrishokBondhon AI is reviewing your question — this usually takes under a minute.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
