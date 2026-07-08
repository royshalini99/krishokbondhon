import 'package:flutter/material.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/auth/screens/otp_screen.dart';
import '../features/onboarding/screens/onboarding_screen.dart';
import '../features/onboarding/screens/splash_screen.dart';
import '../features/home/screens/main_nav_screen.dart';
import '../features/disease_detection/screens/capture_screen.dart';
import '../features/disease_detection/screens/diagnosis_result_screen.dart';
import '../features/disease_detection/screens/diagnosis_history_screen.dart';
import '../features/community/screens/post_detail_screen.dart';
import '../features/community/screens/create_post_screen.dart';
import '../features/qa_support/screens/ask_question_screen.dart';
import '../features/qa_support/screens/question_detail_screen.dart';
import '../features/experts/screens/expert_profile_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/settings_screen.dart';
import '../features/profile/screens/language_screen.dart';
import '../models/user_model.dart';

class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String main = '/main';
  static const String capture = '/capture';
  static const String diagnosisResult = '/diagnosis-result';
  static const String diagnosisHistory = '/diagnosis-history';
  static const String postDetail = '/post-detail';
  static const String createPost = '/create-post';
  static const String askQuestion = '/ask-question';
  static const String questionDetail = '/question-detail';
  static const String expertProfile = '/expert-profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String language = '/language';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _page(const SplashScreen());
      case onboarding:
        return _page(const OnboardingScreen());
      case login:
        return _page(const LoginScreen());
      case register:
        return _page(const RegisterScreen());
      case otp:
        return _page(OtpScreen(phone: settings.arguments as String? ?? ''));
      case main:
        return _page(const MainNavScreen());
      case capture:
        return _page(const CaptureScreen());
      case diagnosisResult:
        return _page(DiagnosisResultScreen(result: settings.arguments));
      case diagnosisHistory:
        return _page(const DiagnosisHistoryScreen());
      case postDetail:
        return _page(PostDetailScreen(post: settings.arguments));
      case createPost:
        return _page(const CreatePostScreen());
      case askQuestion:
        return _page(const AskQuestionScreen());
      case questionDetail:
        return _page(QuestionDetailScreen(question: settings.arguments));
      case expertProfile:
        return _page(ExpertProfileScreen(expert: settings.arguments));
      case editProfile:
        return _page(EditProfileScreen(user: settings.arguments as AppUser?));
      case AppRoutes.settings:
        return _page(const SettingsScreen());
      case language:
        return _page(const LanguageScreen());
      default:
        return _page(const SplashScreen());
    }
  }

  static PageRoute _page(Widget child) {
    return MaterialPageRoute(builder: (_) => child);
  }
}
