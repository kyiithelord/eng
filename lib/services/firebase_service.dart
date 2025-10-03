/// FirebaseService is a placeholder. It does NOT import firebase_* packages
/// to keep the app compiling without Firebase configured. Replace stubs with
/// real implementations after adding Firebase to pubspec and running setup.
class FirebaseService {
  static final FirebaseService instance = FirebaseService._();
  FirebaseService._();

  bool get isEnabled => false; // Flip to true after integrating Firebase

  Future<void> init() async {
    // TODO: Initialize Firebase (firebase_core) and set isEnabled = true
  }

  Future<Map<String, dynamic>?> fetchTodayDailyWord() async {
    // TODO: Read from Firestore collection `daily_word/{yyyy-MM-dd}`
    return null; // Return null to let the cache/asset fallback handle it
  }

  Future<Map<String, dynamic>?> fetchLessons() async {
    // TODO: Read from Firestore collection `lessons` with subcollection `items`
    return null; // Return null to let the cache/asset fallback handle it
  }
}
