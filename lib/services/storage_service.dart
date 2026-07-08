import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_strings.dart';

/// Wraps SharedPreferences (non-sensitive settings) and FlutterSecureStorage
/// (tokens) behind one simple API.
class StorageService {
  StorageService._internal();
  static final StorageService instance = StorageService._internal();

  final _secure = const FlutterSecureStorage();

  Future<void> saveAuthToken(String token) =>
      _secure.write(key: AppStrings.keyAuthToken, value: token);

  Future<String?> getAuthToken() => _secure.read(key: AppStrings.keyAuthToken);

  Future<void> clearAuthToken() => _secure.delete(key: AppStrings.keyAuthToken);

  Future<void> setOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppStrings.keyOnboardingDone, true);
  }

  Future<bool> isOnboardingDone() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppStrings.keyOnboardingDone) ?? false;
  }

  Future<void> saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.keyLocale, code);
  }

  Future<String?> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.keyLocale);
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppStrings.keyUserName, name);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppStrings.keyUserName);
  }
}
