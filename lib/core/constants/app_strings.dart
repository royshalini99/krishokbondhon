/// Static, non-translated strings (brand names, keys). User-facing copy
/// that needs translation lives in assets/lang/*.json and is accessed via
/// easy_localization's `.tr()` extension — see l10n/ for keys.
class AppStrings {
  AppStrings._();

  static const String appName = 'KrishokBondhon';
  static const String appTagline = 'Your AI companion in the field';

  // Storage keys
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keyLocale = 'app_locale';
  static const String keyUserName = 'user_name';
  static const String keyUserRole = 'user_role';

  // Supported locales (code -> native display name)
  static const Map<String, String> supportedLocales = {
    'en': 'English',
    'as': 'অসমীয়া (Assamese)',
    'kha': 'Khasi',
    'grt': 'A·chik (Garo)',
    'mni': 'ꯃꯤꯇꯩꯂꯣꯟ (Manipuri)',
  };
}
