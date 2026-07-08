import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

class AppStateProvider extends ChangeNotifier {
  AppUser? _currentUser;
  String _localeCode = 'en';
  bool _isAuthenticated = false;

  AppUser? get currentUser => _currentUser;
  String get localeCode => _localeCode;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> bootstrap() async {
    final savedLocale = await StorageService.instance.getLocale();
    if (savedLocale != null) _localeCode = savedLocale;

    final token = await StorageService.instance.getAuthToken();
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> setLocale(String code) async {
    _localeCode = code;
    await StorageService.instance.saveLocale(code);
    notifyListeners();
  }

  void loginSuccess(AppUser user) {
    _currentUser = user;
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    _isAuthenticated = false;
    await StorageService.instance.clearAuthToken();
    notifyListeners();
  }

  void updateProfile(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }
}
