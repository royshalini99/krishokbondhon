enum AnswerSource { ai, expert, farmer }

AnswerSource _answerSourceFromString(String? s) {
  switch (s) {
    case 'expert':
      return AnswerSource.expert;
    case 'farmer':
      return AnswerSource.farmer;
    case 'ai':
    default:
      return AnswerSource.ai;
  }
}

class QnaAnswer {
  final String id;
  final AnswerSource source;
  final String authorName;
  final String content;
  final bool verified;
  final DateTime createdAt;

  const QnaAnswer({
    required this.id,
    required this.source,
    required this.authorName,
    required this.content,
    this.verified = false,
    required this.createdAt,
  });

  factory QnaAnswer.fromJson(Map<String, dynamic> json) => QnaAnswer(
        id: json['id'] as String,
        source: _answerSourceFromString(json['source'] as String?),
        authorName: json['authorName'] as String? ?? 'Unknown',
        content: json['content'] as String? ?? '',
        verified: json['verified'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      );
}

/// Mirrors the backend `status` field: `pending` while the NLP microservice
/// is still generating the AI answer, `answered` once it (or an
/// expert/farmer) has replied.
enum QuestionStatus { pending, answered }

class QnaQuestion {
  final String id;
  final String authorName;
  final String title;
  final String? imagePath;
  final String cropType;
  final List<QnaAnswer> answers;
  final DateTime createdAt;
  final QuestionStatus status;

  const QnaQuestion({
    required this.id,
    required this.authorName,
    required this.title,
    this.imagePath,
    required this.cropType,
    this.answers = const [],
    required this.createdAt,
    this.status = QuestionStatus.pending,
  });

  bool get resolved => status == QuestionStatus.answered;
  bool get hasAiAnswer => answers.any((a) => a.source == AnswerSource.ai);

  factory QnaQuestion.fromJson(Map<String, dynamic> json) => QnaQuestion(
        id: json['id'] as String,
        authorName: (json['author'] as Map<String, dynamic>?)?['name'] as String? ?? 'Unknown',
        title: json['title'] as String? ?? '',
        imagePath: json['imageUrl'] as String?,
        cropType: json['cropType'] as String? ?? 'Other',
        answers: (json['answers'] as List? ?? const [])
            .map((e) => QnaAnswer.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
        status: (json['status'] as String?) == 'answered' ? QuestionStatus.answered : QuestionStatus.pending,
      );

  QnaQuestion copyWith({List<QnaAnswer>? answers, QuestionStatus? status}) => QnaQuestion(
        id: id,
        authorName: authorName,
        title: title,
        imagePath: imagePath,
        cropType: cropType,
        answers: answers ?? this.answers,
        createdAt: createdAt,
        status: status ?? this.status,
      );
}
