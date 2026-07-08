# KrishokBondhon — Flutter App

AI-powered smart & sustainable farming companion for tomato and potato
farmers in Assam and Meghalaya. This is the mobile client, built to sit
alongside the existing React web frontend, Node.js API gateway, and
Python FastAPI microservices (disease detection, NLP/Q&A).

## What's in this scaffold

Every screen described below is **fully built and navigable** with a
bright, Material 3 design and realistic mock data, so you can click
through the whole app today. Network calls are stubbed with clearly
marked `// TODO` comments pointing at the exact endpoint to wire up next.

### Feature map

| Feature | Screens | Status |
|---|---|---|
| Onboarding | Splash, 3-page swipeable intro | UI done |
| Auth | Login (phone), Register, OTP verification | UI done, mock token |
| Home dashboard | Weather advisory, quick actions, recent diagnoses, tip of the day | UI done, mock data |
| Disease detection | Camera/gallery capture → result screen w/ severity, remedies → history grid | UI done, camera picker wired, AI call stubbed |
| Community (F2F networking) | Feed w/ filters & likes, post detail w/ comments, create post | UI done, mock data |
| Q&A support | Question list, ask question (+ voice input), question detail (AI/expert/farmer answers, text-to-speech playback) | UI done, speech-to-text/TTS wired, AI/backend call stubbed |
| Experts | Expert directory, expert profile | UI done, mock data |
| Profile | Profile home, edit profile, settings, language picker | UI done |
| Multilingual | English + Assamese fully drafted; Khasi/Garo/Manipuri scaffolded (need native-speaker review) | Locale switch UI done; wiring into `easy_localization` is the next step |

## Folder structure

```
lib/
  main.dart                 — entry point, Provider setup
  app.dart                  — root MaterialApp, theme, routing
  core/
    constants/               — colors, strings, API endpoint paths
    theme/                   — AppTheme (Material 3, bright green/amber palette)
    widgets/                 — PrimaryButton, AppTextField, SectionHeader, EmptyState
  config/
    routes.dart              — named routes + onGenerateRoute
  providers/
    app_state_provider.dart  — auth state + locale (Provider/ChangeNotifier)
  services/
    api_service.dart         — Dio client -> Node.js gateway
    storage_service.dart     — secure storage (tokens) + SharedPreferences
    voice_service.dart       — speech_to_text + flutter_tts wrapper
    mock_data_service.dart   — sample data powering every screen today
  models/
    user_model.dart
  features/
    onboarding/  auth/  home/  disease_detection/  community/  qa_support/  experts/  profile/
      each has screens/ (and models/, widgets/ where relevant)
  l10n/                      — reserved for easy_localization delegate setup
assets/
  images/  icons/  fonts/  lang/ (en.json, as.json, kha.json, grt.json, mni.json)
```

## Getting it running

```bash
flutter pub get
flutter run
```

The app boots straight into a working demo: onboarding → phone login →
any 6-digit OTP → home dashboard → every tab and sub-screen is reachable.

## Suggested build order for wiring the real backend

1. **Auth**: point `login_screen.dart` / `otp_screen.dart` at
   `ApiConstants.login` / `sendOtp` / `verifyOtp`, store the real JWT via
   `StorageService`.
2. **Disease detection**: replace the stub in `capture_screen.dart`
   (`_analyze()`) with a multipart POST to `ApiConstants.diagnoseCrop`,
   parse the response into `DiseaseResult`.
3. **Community feed**: swap `MockDataService.feed()` for a paginated GET
   to `ApiConstants.feed`, wire `create_post_screen.dart` to POST.
4. **Q&A**: wire `ask_question_screen.dart` to `ApiConstants.askQuestion`
   and poll/subscribe (Socket.IO client is already a dependency) for new
   AI/expert/farmer answers on `question_detail_screen.dart`.
5. **Experts**: GET `ApiConstants.expertList` / `expertProfile`.
6. **Localization**: move the hardcoded English strings into
   `assets/lang/en.json` (already scaffolded) and initialize
   `easy_localization` in `main.dart`; the language picker UI and locale
   persistence are already wired to `AppStateProvider`.
7. **Android/iOS platform folders**: not included in this scaffold — run
   `flutter create .` inside this directory once to generate them, which
   will merge in the platform folders without touching `lib/`.

## Notes

- State management: `provider` (simple, matches team size/complexity).
  Swap for Riverpod/Bloc later without touching the UI layer if needed.
- Design tokens live in `core/constants/app_colors.dart` — change the
  palette there and it propagates everywhere via `AppTheme`.
- The Khasi/Garo/Manipuri translation files are placeholders and are
  flagged with a `_note` key — get these reviewed by native speakers
  before shipping, per the project's multilingual accessibility goal.
