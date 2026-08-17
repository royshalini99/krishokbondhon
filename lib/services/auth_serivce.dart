import 'package:dio/dio.dart';
import '../core/constants/api_constants.dart';
import '../models/user_model.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  Future<String?> register({
    required String name,
    required String phone,
    String? village,
    String? district,
    String? state,
    List<String> crops = const [],
    String preferredLanguage = 'en',
    String role = 'farmer',
  }) async {
    try {
      await _dio.post('/auth/register', data: {
        'name': name,
        'phone': phone,
        'village': village,
        'district': district,
        'state': state,
        'crops': crops,
        'preferredLanguage': preferredLanguage,
        'role': role,
      });
      return null;
    } on DioException catch (e) {
      return e.response?.data['error'] ?? 'Something went wrong. Please try again.';
    } catch (e) {
      return 'Could not reach the server. Check your internet connection.';
    }
  }

  Future<String?> sendOtp({required String phone}) async {
    try {
      await _dio.post('/auth/send-otp', data: {'phone': phone});
      return null;
    } on DioException catch (e) {
      return e.response?.data['error'] ?? 'Could not send OTP. Please try again.';
    } catch (e) {
      return 'Could not reach the server. Check your internet connection.';
    }
  }

  Future<({String? error, AppUser? user, String? token})> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {'phone': phone, 'otp': otp});
      final token = response.data['token'] as String;
      final user = AppUser.fromJson(response.data['user']);
      return (error: null, user: user, token: token);
    } on DioException catch (e) {
      return (error: e.response?.data['error'] as String? ?? 'Invalid OTP. Please try again.', user: null, token: null);
    } catch (e) {
      return (error: 'Could not reach the server. Check your internet connection.', user: null, token: null);
    }
  }

  Future<AppUser?> getMe(String token) async {
    try {
      final response = await _dio.get('/auth/me', options: Options(headers: {'Authorization': 'Bearer $token'}));
      return AppUser.fromJson(response.data['user']);
    } catch (e) {
      return null;
    }
  }

  Future<({String? error, AppUser? user})> updateProfile({
    required String userId,
    String? village,
    String? district,
    String? state,
    String? preferredLanguage,
    List<String>? crops,
  }) async {
    try {
      final response = await _dio.patch('/auth/profile/$userId', data: {
        if (village != null) 'village': village,
        if (district != null) 'district': district,
        if (state != null) 'state': state,
        if (preferredLanguage != null) 'preferredLanguage': preferredLanguage,
        if (crops != null) 'crops': crops,
      });
      return (error: null, user: AppUser.fromJson(response.data['user']));
    } on DioException catch (e) {
      return (error: e.response?.data['error'] as String? ?? 'Could not update profile.', user: null);
    } catch (e) {
      return (error: 'Could not reach the server. Check your internet connection.', user: null);
    }
  }

  Future<String?> sendEmailOtp({required String userId, required String email}) async {
    try {
      await _dio.post('/auth/email/send-otp', data: {'userId': userId, 'email': email});
      return null;
    } on DioException catch (e) {
      return e.response?.data['error'] ?? 'Could not send verification code.';
    } catch (e) {
      return 'Could not reach the server. Check your internet connection.';
    }
  }

  Future<({String? error, AppUser? user})> verifyEmailOtp({
    required String userId,
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _dio.post('/auth/email/verify-otp', data: {
        'userId': userId,
        'email': email,
        'otp': otp,
      });
      return (error: null, user: AppUser.fromJson(response.data['user']));
    } on DioException catch (e) {
      return (error: e.response?.data['error'] as String? ?? 'Invalid code.', user: null);
    } catch (e) {
      return (error: 'Could not reach the server. Check your internet connection.', user: null);
    }
  }

  /// Submits an expert's institution/specialty for admin review.
  Future<String?> submitExpertProfile({
    required String userId,
    required String institution,
    required String specialty,
    String? credentialsDocUrl,
  }) async {
    try {
      await _dio.post('/auth/expert/profile', data: {
        'userId': userId,
        'institution': institution,
        'specialty': specialty,
        'credentialsDocUrl': credentialsDocUrl,
      });
      return null;
    } on DioException catch (e) {
      return e.response?.data['error'] ?? 'Could not submit expert profile.';
    } catch (e) {
      return 'Could not reach the server. Check your internet connection.';
    }
  }

  /// Admin-only: fetches every expert profile still awaiting approval.
  Future<({String? error, List<dynamic>? experts})> getPendingExperts(String token) async {
    try {
      final response = await _dio.get(
        '/auth/expert/pending',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return (error: null, experts: response.data['experts'] as List<dynamic>);
    } on DioException catch (e) {
      return (error: e.response?.data['error'] as String? ?? 'Could not load pending experts.', experts: null);
    } catch (e) {
      return (error: 'Could not reach the server. Check your internet connection.', experts: null);
    }
  }

  /// Admin-only: approves a pending expert profile.
  Future<String?> approveExpert({required String expertId, required String token}) async {
    try {
      await _dio.patch(
        '/auth/expert/$expertId/approve',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return null;
    } on DioException catch (e) {
      return e.response?.data['error'] ?? 'Could not approve expert.';
    } catch (e) {
      return 'Could not reach the server. Check your internet connection.';
    }
  }
}