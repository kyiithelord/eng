# EngApp (Flutter Scaffold)

A Myanmar-focused English learning app scaffold. Includes core screens, routing, local streaks, Hive caching, an Ad banner placeholder, and a recording flow with mock AI scoring. Firebase is stubbed for later.

## Prerequisites
- Flutter SDK installed
- Android Studio / Xcode for platform builds (Android recommended first)

## Setup
```bash
# in the engapp directory
flutter pub get
# if android/ios/web folders are missing (created when using flutter create), run:
# flutter create .
flutter run
```

## Features (MVP scaffold)
- Home: Daily word (from assets) with Hive cache, streak counter (SharedPreferences)
- Lessons: Categories loaded from assets with Hive cache
- Practice: Recording via `record` and mock AI scoring (no backend required)
- Premium: upsell placeholder
- Settings: Language toggle placeholder
- Ad Banner: Placeholder UI in `AppScaffold` (replace with AdMob later)

## Next Steps
- Replace Ad placeholder with AdMob (`google_mobile_ads`)
- Integrate Firebase (Auth, Firestore, Storage)
- Add AI pronunciation via a Cloud Function proxy (Whisper)
- Implement in-app purchases

## Structure
```
lib/
  main.dart
  routing/app_router.dart
  services/streak_service.dart
  services/cache_service.dart
  services/ai_service.dart
  services/firebase_service.dart
  widgets/app_scaffold.dart
  features/
    home/home_screen.dart
    lessons/lessons_screen.dart
    practice/practice_screen.dart
    premium/premium_screen.dart
    settings/settings_screen.dart
assets/
  daily/sample.json
  lessons/sample_lessons.json
  strings/en.json
  strings/my.json
```

## Firebase (when you're ready)
1) Add packages to `pubspec.yaml`: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`.
2) Run setup:
   - flutterfire configure
   - flutter pub get
3) Initialize in `main.dart` before `runApp`:
   - await Firebase.initializeApp();
4) Implement reads in `lib/services/firebase_service.dart` and flip `isEnabled` to true.
5) Update `HomeScreen`/`LessonsScreen` to try Firebase first, then fall back to cache/assets.
