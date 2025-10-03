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
- Ad Banner: Real `google_mobile_ads` BannerAd using Google test unit

## Next Steps
- Replace test Ad unit with your real AdMob unit, add App ID to AndroidManifest
- Configure Firebase via `flutterfire configure`, seed Firestore data
- Deploy AI scoring Cloud Function and set `AppConfig.aiEndpoint`
- Set up Play billing products and test IAP

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

1) Add packages to `pubspec.yaml`: `firebase_core`, `cloud_firestore`, `firebase_auth`, `firebase_storage`.
2) Run setup:
   - flutterfire configure
   - flutter pub get
3) Initialize in `main.dart` before `runApp`:
   - import generated `firebase_options.dart` and call:
   - await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
4) Implement reads in `lib/services/firebase_service.dart` and flip `isEnabled` to true.
5) Update `HomeScreen`/`LessonsScreen` to try Firebase first, then fall back to cache/assets.

Firestore structure expected by code:
- Collection `daily_word/{yyyy-MM-dd}` documents with fields: `text`, `translation_my`, `audioUrl`, `examples` (optional)
- Collection `lessons` (with `order`, `title`, `description` optional) and subcollection `items` (each with `order`, `text`, `translation_my`, `example`/`examples`)

### AI Pronunciation (Cloud Function)
For now, `AiService` will call a configured HTTP endpoint if set, else returns a mock score.
1) Create a Cloud Function endpoint that accepts:
   ```json
   { "expectedText": "Nice to meet you", "audioBase64": "...", "mimeType": "audio/aac" }
   ```
2) The function should:
   - Transcribe with Whisper (or Google STT)
   - Compute WER/CER vs `expectedText`
   - Return `{ score: 0-100, feedback: string }`
3) Set the endpoint in `lib/services/app_config.dart` → `AppConfig.aiEndpoint`.

Example Functions scaffold (TypeScript) placed in `functions/` with `package.json`. You will still need to write the handler and add your OpenAI key as env config.

### In-App Purchases (IAP)
We added a simple integration using `in_app_purchase`:
1) Create a non-consumable product in Play Console with product ID `premium_tier` (or update the ID in `PurchaseService.premiumProductId`).
2) Ensure your app is uploaded to internal testing and your account is a tester.
3) On device, the Premium screen will query the product and offer purchase.
4) Server-side receipt verification is recommended (stub TODO in code).

### Android Permissions
- Recording: Ensure `android/app/src/main/AndroidManifest.xml` includes:
  ```xml
  <uses-permission android:name="android.permission.RECORD_AUDIO" />
  ```
