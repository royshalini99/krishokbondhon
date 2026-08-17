/// Base URLs and endpoint paths.
class ApiConstants {
  ApiConstants._();

  // Android emulator's alias for your PC's localhost. For a real device,
  // swap to your PC's LAN IP, e.g. 'http://192.168.1.42:4000/v1'.
  // Override via --dart-define=API_BASE_URL=... for staging/production builds.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:4000/v1',
  );

  static const String socketUrl = String.fromEnvironment(
    'SOCKET_URL',
    defaultValue: 'http://10.0.2.2:4000',
  );

  // Auth (passwordless OTP flow)
  static const String register = '/auth/register';
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String me = '/auth/me';

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
  static const String updateProfile = '/auth/profile/{id}';

  // Weather / advisory
  static const String weatherAdvisory = '/advisory/weather';

  static String withId(String template, String id) => template.replaceAll('{id}', id);

  /// Turns a relative upload path (e.g. "/uploads/169...-photo.jpg", as
  /// returned when STORAGE_DRIVER=local) into a full, loadable URL. Full
  /// URLs (e.g. from Google Cloud Storage in production) are returned
  /// unchanged, since they already point at the right place.
  static String resolveImageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }
    // /uploads is served at the API root, not under /v1 — see app.js's
    // `app.use('/uploads', express.static(...))`.
    final root = baseUrl.replaceAll('/v1', '');
    return '$root$path';
  }

  static const String deletePost = '/community/posts/{id}';
}