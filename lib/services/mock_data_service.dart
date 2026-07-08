import '../features/community/models/community_post.dart';
import '../features/disease_detection/models/disease_result.dart';
import '../features/experts/models/expert_model.dart';
import '../features/qa_support/models/qna_question.dart';

/// Provides realistic sample data so every screen renders fully populated
/// and "alive" before the real API integration lands (Track: UI-first
/// development, matching the phased backend rollout).
class MockDataService {
  MockDataService._();

  static List<CommunityPost> feed() => [
        CommunityPost(
          id: 'p1',
          author: const PostAuthor(id: 'u1', name: 'Ratul Deb', village: 'Katigorah, Cachar'),
          content:
              'Late blight showing up on my potato leaves this week because of the humidity. Sprayed neem oil solution — anyone else seeing this in Barak Valley?',
          images: const [],
          likeCount: 18,
          commentCount: 6,
          tags: const ['Potato', 'Late Blight'],
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        CommunityPost(
          id: 'p2',
          author: const PostAuthor(id: 'u2', name: 'Momita Sangma', village: 'Tura, West Garo Hills'),
          content:
              'Harvested my first batch of tomatoes using the raised-bed method the app recommended. Yield is up almost 20% from last season!',
          likeCount: 42,
          commentCount: 11,
          likedByMe: true,
          tags: const ['Tomato', 'Success Story'],
          createdAt: DateTime.now().subtract(const Duration(hours: 7)),
        ),
        CommunityPost(
          id: 'p3',
          author: const PostAuthor(id: 'u3', name: 'Ibaphira Lyngdoh', village: 'Mawlai, East Khasi Hills'),
          content:
              'Question for the group — best organic remedy for aphids on tomato saplings? Chemical sprays are hard to source right now.',
          likeCount: 9,
          commentCount: 14,
          tags: const ['Tomato', 'Pest Control'],
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

  static List<QnaQuestion> questions() => [
        QnaQuestion(
          id: 'q1',
          authorName: 'Anupam Nath',
          title: 'Yellow curling leaves on tomato — nutrient deficiency or virus?',
          cropType: 'Tomato',
          status: QuestionStatus.answered,
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          answers: [
            QnaAnswer(
              id: 'a1',
              source: AnswerSource.ai,
              authorName: 'KrishokBondhon AI',
              content:
                  'Based on the image, symptoms match Tomato Leaf Curl Virus spread by whiteflies rather than a nutrient issue. Consider removing affected plants and controlling whitefly populations.',
              createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            ),
            QnaAnswer(
              id: 'a2',
              source: AnswerSource.expert,
              authorName: 'Dr. Bornali Gogoi, Assam Agricultural University',
              content:
                  'Confirmed — this is viral, not nutritional. Use yellow sticky traps and reflective mulch to manage whitefly vectors; there is no cure once infected.',
              verified: true,
              createdAt: DateTime.now().subtract(const Duration(hours: 4)),
            ),
          ],
        ),
        QnaQuestion(
          id: 'q2',
          authorName: 'Silchan Marak',
          title: 'When is the ideal planting window for potato in Meghalaya hills?',
          cropType: 'Potato',
          status: QuestionStatus.answered,
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
          answers: [
            QnaAnswer(
              id: 'a3',
              source: AnswerSource.farmer,
              authorName: 'Tenzin Rai',
              content: 'In the West Khasi Hills we plant right after the first week of October, once the heavy rains ease off.',
              createdAt: DateTime.now().subtract(const Duration(hours: 18)),
            ),
          ],
        ),
      ];

  static List<Expert> experts() => const [
        Expert(
          id: 'e1',
          name: 'Dr. Bornali Gogoi',
          designation: 'Plant Pathologist',
          institution: 'Assam Agricultural University',
          specialization: ['Tomato', 'Potato', 'Fungal Disease'],
          languages: ['English', 'Assamese'],
          rating: 4.9,
          questionsAnswered: 312,
          online: true,
        ),
        Expert(
          id: 'e2',
          name: 'Wanpynhun Kharkongor',
          designation: 'Agriculture Extension Officer',
          institution: 'ICAR Meghalaya',
          specialization: ['Soil Health', 'Organic Farming'],
          languages: ['English', 'Khasi'],
          rating: 4.7,
          questionsAnswered: 198,
        ),
        Expert(
          id: 'e3',
          name: 'Prof. Naba Kumar Sarma',
          designation: 'Entomologist',
          institution: 'Assam Agricultural University',
          specialization: ['Pest Management'],
          languages: ['English', 'Assamese'],
          rating: 4.8,
          questionsAnswered: 256,
          online: true,
        ),
      ];

  static List<DiseaseResult> diagnosisHistory() => [
        DiseaseResult(
          id: 'd1',
          imagePath: '',
          cropType: 'Tomato',
          diseaseName: 'Early Blight',
          confidence: 0.93,
          severity: DiseaseSeverity.moderate,
          description: 'Fungal disease causing dark concentric rings on lower leaves.',
          remedies: const [
            'Remove and destroy infected leaves',
            'Apply copper-based fungicide every 7-10 days',
            'Improve air circulation between plants',
          ],
          detectedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DiseaseResult(
          id: 'd2',
          imagePath: '',
          cropType: 'Potato',
          diseaseName: 'Late Blight',
          confidence: 0.88,
          severity: DiseaseSeverity.severe,
          description: 'Water-soaked lesions that spread rapidly in humid conditions.',
          remedies: const [
            'Apply fungicide containing chlorothalonil immediately',
            'Remove infected plants to stop spread',
            'Avoid overhead irrigation',
          ],
          detectedAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];
}
