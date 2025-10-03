# EngApp (Flutter Scaffold)

A Myanmar-focused English learning app scaffold. This repo includes core screens, routing, and local streak logic using `SharedPreferences`. No Firebase yet, so it runs offline.

## Prerequisites
- Flutter SDK installed
- Android Studio / Xcode for platform builds (Android recommended first)

## Setup
```bash
# in the engapp directory
flutter pub get
# if android/ios folders are missing (created when using flutter create), run:
# flutter create .
flutter run
```

## Features (MVP scaffold)
- Home: Daily word placeholder, streak counter
- Lessons: Category placeholders
- Practice: Recording placeholder (no AI yet)
- Premium: Upsell placeholder
- Settings: Language toggle placeholder

## Next Steps
- Integrate Firebase (Auth, Firestore, Storage)
- Add AI pronunciation via a Cloud Function proxy
- Implement ads (AdMob) and in-app purchases
- Offline caching with Hive

## Structure
```
lib/
  main.dart
  routing/app_router.dart
  services/streak_service.dart
  widgets/app_scaffold.dart
  features/
    home/home_screen.dart
    lessons/lessons_screen.dart
    practice/practice_screen.dart
    premium/premium_screen.dart
    settings/settings_screen.dart
assets/
  daily/sample.json
  strings/en.json
  strings/my.json
```
