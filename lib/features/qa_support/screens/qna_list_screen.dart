import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/section_header.dart';
import '../models/qna_question.dart';
import '../../../services/qna_service.dart';
import '../widgets/question_card.dart';
import '../../../config/routes.dart';

class QnaListScreen extends StatefulWidget {
  const QnaListScreen({super.key});

  @override
  State<QnaListScreen> createState() => _QnaListScreenState();
}

class _QnaListScreenState extends State<QnaListScreen> {
  final _service = QnaService.instance;

  List<QnaQuestion> _questions = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final page = await _service.fetchQuestions();
      setState(() {
        _questions = page.items;
        _loading = false;
      });
    } catch (_) {
      setState(() {
        _loading = false;
        _error = "Couldn't load questions. Pull down to retry.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask & Answer')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: AppColors.heroGradient),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 34),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Got a farming question?',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ask by text or voice — AI, experts and fellow farmers will help.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Recent questions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_error != null)
              EmptyState(
                icon: Icons.wifi_off_rounded,
                title: 'Unable to load questions',
                message: _error!,
                action: OutlinedButton(onPressed: _load, child: const Text('Retry')),
              )
            else if (_questions.isEmpty)
              const EmptyState(
                icon: Icons.forum_outlined,
                title: 'No questions yet',
                message: 'Ask the first question — AI, experts, and farmers are ready to help.',
              )
            else
              ..._questions.map((q) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: QuestionCard(question: q),
                  )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final asked = await Navigator.pushNamed(context, AppRoutes.askQuestion);
          if (asked == true) _load();
        },
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('Ask'),
      ),
    );
  }
}
