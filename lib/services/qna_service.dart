import 'dart:async';
import '../core/constants/api_constants.dart';
import 'api_service.dart';
import '../features/qa_support/models/qna_question.dart';
import '../models/paginated.dart';

/// Talks to the `/qna/*` endpoints on the Node.js gateway.
/// See docs/API_CONTRACT.md for the exact request/response shapes.
///
/// AI answers are generated asynchronously by the NLP microservice, so
/// [watchQuestion] polls [ApiConstants.questionThread] every few seconds
/// until the question's status flips to `answered`. If you later add a
/// Socket.IO push from the backend, this is the only method that needs
/// to change — screens consume the same Stream either way.
class QnaService {
  QnaService._();
  static final QnaService instance = QnaService._();

  final _api = ApiService.instance;

  Future<Paginated<QnaQuestion>> fetchQuestions({String? cursor, String? crop, int limit = 20}) async {
    final response = await _api.get(
      ApiConstants.questionList,
      query: {
        if (cursor != null) 'cursor': cursor,
        if (crop != null && crop != 'All') 'crop': crop,
        'limit': limit,
      },
    );
    return Paginated.fromJson(
      response.data as Map<String, dynamic>,
      (json) => QnaQuestion.fromJson(json),
    );
  }

  Future<QnaQuestion> fetchQuestion(String id) async {
    final response = await _api.get(ApiConstants.withId(ApiConstants.questionThread, id));
    return QnaQuestion.fromJson(response.data as Map<String, dynamic>);
  }

  /// Submits a new question. Returns immediately with `status: pending` —
  /// the AI answer is not attached yet. Pair this with [watchQuestion] on
  /// the following screen to pick up the answer once it's ready.
  Future<QnaQuestion> askQuestion({
    required String title,
    required String cropType,
    String? imageUrl,
  }) async {
    final response = await _api.post(
      ApiConstants.askQuestion,
      data: {
        'title': title,
        'cropType': cropType,
        if (imageUrl != null) 'imageUrl': imageUrl,
      },
    );
    return QnaQuestion.fromJson(response.data as Map<String, dynamic>);
  }

  Future<QnaAnswer> addAnswer(String questionId, String content) async {
    final response = await _api.post(
      ApiConstants.withId(ApiConstants.questionAnswers, questionId),
      data: {'content': content},
    );
    return QnaAnswer.fromJson(response.data as Map<String, dynamic>);
  }

  /// Polls the question every [interval] until it's answered or [timeout]
  /// elapses, emitting each fetched snapshot. The screen can show a
  /// "your question is being reviewed" state while this stream is live.
  Stream<QnaQuestion> watchQuestion(
    String id, {
    Duration interval = const Duration(seconds: 4),
    Duration timeout = const Duration(minutes: 2),
  }) async* {
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      final question = await fetchQuestion(id);
      yield question;
      if (question.status == QuestionStatus.answered) return;
      await Future.delayed(interval);
    }
  }
}
