enum DiseaseSeverity { healthy, mild, moderate, severe }

class DiseaseResult {
  final String id;
  final String imagePath;
  final String cropType;
  final String diseaseName;
  final double confidence;
  final DiseaseSeverity severity;
  final String description;
  final List<String> remedies;
  final DateTime detectedAt;

  const DiseaseResult({
    required this.id,
    required this.imagePath,
    required this.cropType,
    required this.diseaseName,
    required this.confidence,
    required this.severity,
    required this.description,
    required this.remedies,
    required this.detectedAt,
  });

  factory DiseaseResult.fromJson(Map<String, dynamic> json) {
    return DiseaseResult(
      id: json['id'] as String,
      imagePath: json['imagePath'] as String,
      cropType: json['cropType'] as String,
      diseaseName: json['diseaseName'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      severity: DiseaseSeverity.values.firstWhere(
        (s) => s.name == json['severity'],
        orElse: () => DiseaseSeverity.moderate,
      ),
      description: json['description'] as String? ?? '',
      remedies: (json['remedies'] as List?)?.map((e) => e.toString()).toList() ?? const [],
      detectedAt: DateTime.tryParse(json['detectedAt'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
