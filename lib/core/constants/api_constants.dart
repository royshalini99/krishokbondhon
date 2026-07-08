/// Base URLs and endpoint paths.
/// Points at the Node.js API gateway which fronts the FastAPI microservices
/// (disease detection, NLP/Q&A) described in the KrishokBondhon backend.
class ApiConstants {
  ApiConstants._();

  // Swap via --dart-define=API_BASE_URL=... at build time for prod/staging.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.krishokbondhon.org/v1',
  );

  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'https://api.krishokbondhon.org',
  );

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/otp/send';
  static const String verifyOtp = '/auth/otp/verify';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // Disease detection
  static const String diagnoseCrop = '/disease/diagnose';
  static const String diagnosisHistory = '/disease/history';
  static const String diseaseLibrary = '/disease/library';

  // Community (F2F networking)
  static const String feed = '/community/feed';
  static const String createPost = '/community/posts';
  static const String postComments = '/community/posts/{id}/comments';
  static const String likePost = '/community/posts/{id}/like';

  // Q&A / AI support
  static const String askQuestion = '/qna/ask';
  static const String questionThread = '/qna/questions/{id}';
  static const String questionList = '/qna/questions';
  static const String questionAnswers = '/qna/questions/{id}/answers';

  // Experts
  static const String expertList = '/experts';
  static const String expertProfile = '/experts/{id}';

  // Profile
  static const String profile = '/users/me';
  static const String updateProfile = '/users/me';

  // Weather / advisory
  static const String weatherAdvisory = '/advisory/weather';

  /// Substitutes the `{id}` placeholder in templates like [postComments],
  /// [likePost], [questionThread], [questionAnswers], [expertProfile].
  static String withId(String template, String id) => template.replaceAll('{id}', id);
}
