class Expert {
  final String id;
  final String name;
  final String designation;
  final String institution;
  final List<String> specialization;
  final List<String> languages;
  final double rating;
  final int questionsAnswered;
  final String? avatarUrl;
  final bool verified;
  final bool online;

  const Expert({
    required this.id,
    required this.name,
    required this.designation,
    required this.institution,
    this.specialization = const [],
    this.languages = const [],
    this.rating = 0,
    this.questionsAnswered = 0,
    this.avatarUrl,
    this.verified = true,
    this.online = false,
  });
}
