import 'package:flutter/material.dart';
import '../../../services/auth_serivce.dart';
import '../../../services/storage_service.dart';
import '../../../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isCheckingSession = true;
  bool get isCheckingSession => _isCheckingSession;

  Future<void> checkSavedSession() async {
    _isCheckingSession = true;
    notifyListeners();

    final token = await StorageService.instance.getAuthToken();

    if (token != null) {
      final user = await _authService.getMe(token);
      if (user != null) {
        _currentUser = user;
      } else {
        await StorageService.instance.clearAuthToken();
        _currentUser = null;
      }
    }

    _isCheckingSession = false;
    notifyListeners();
  }

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
    _isLoading = true;
    notifyListeners();

    final error = await _authService.register(
      name: name,
      phone: phone,
      village: village,
      district: district,
      state: state,
      crops: crops,
      preferredLanguage: preferredLanguage,
      role: role,
    );

    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> sendOtp({required String phone}) async {
    _isLoading = true;
    notifyListeners();
    final error = await _authService.sendOtp(phone: phone);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> verifyOtp({required String phone, required String otp}) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.verifyOtp(phone: phone, otp: otp);

    if (result.error == null && result.token != null && result.user != null) {
      await StorageService.instance.saveAuthToken(result.token!);
      _currentUser = result.user;
    }

    _isLoading = false;
    notifyListeners();
    return result.error;
  }

  Future<String?> updateProfile({
    String? village,
    String? district,
    String? state,
    String? preferredLanguage,
    List<String>? crops,
  }) async {
    if (_currentUser == null) return 'Not logged in.';

    _isLoading = true;
    notifyListeners();

    final result = await _authService.updateProfile(
      userId: _currentUser!.id,
      village: village,
      district: district,
      state: state,
      preferredLanguage: preferredLanguage,
      crops: crops,
    );

    if (result.error == null && result.user != null) {
      _currentUser = result.user;
    }

    _isLoading = false;
    notifyListeners();
    return result.error;
  }

  Future<String?> sendEmailOtp({required String email}) async {
    if (_currentUser == null) return 'Not logged in.';
    _isLoading = true;
    notifyListeners();
    final error = await _authService.sendEmailOtp(userId: _currentUser!.id, email: email);
    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<String?> verifyEmailOtp({required String email, required String otp}) async {
    if (_currentUser == null) return 'Not logged in.';
    _isLoading = true;
    notifyListeners();

    final result = await _authService.verifyEmailOtp(userId: _currentUser!.id, email: email, otp: otp);

    if (result.error == null && result.user != null) {
      _currentUser = result.user;
    }

    _isLoading = false;
    notifyListeners();
    return result.error;
  }

  /// Submits the expert profile for the just-registered (or logged-in)
  /// expert user, using their id automatically.
  Future<String?> submitExpertProfile({
    required String institution,
    required String specialty,
    String? credentialsDocUrl,
  }) async {
    if (_currentUser == null) return 'Not logged in.';
    _isLoading = true;
    notifyListeners();

    final error = await _authService.submitExpertProfile(
      userId: _currentUser!.id,
      institution: institution,
      specialty: specialty,
      credentialsDocUrl: credentialsDocUrl,
    );

    _isLoading = false;
    notifyListeners();
    return error;
  }

  Future<void> logout() async {
    await StorageService.instance.clearAuthToken();
    _currentUser = null;
    notifyListeners();
  }
}