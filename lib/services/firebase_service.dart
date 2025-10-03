import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._();
  FirebaseService._();

  bool _enabled = false;
  bool get isEnabled => _enabled;

  Future<void> init() async {
    try {
      // If flutterfire configure is done, this will work (or if google-services.json is present on Android)
      await Firebase.initializeApp();
      _enabled = true;
    } catch (_) {
      _enabled = false; // keep disabled if not configured
    }
  }

  Future<Map<String, dynamic>?> fetchTodayDailyWord() async {
    if (!_enabled) return null;
    try {
      final now = DateTime.now();
      final id = _fmt(now);
      final snap = await FirebaseFirestore.instance.collection('daily_word').doc(id).get();
      if (!snap.exists) return null;
      final data = snap.data();
      if (data == null) return null;
      return Map<String, dynamic>.from(data);
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchLessons() async {
    if (!_enabled) return null;
    try {
      final catsSnap = await FirebaseFirestore.instance.collection('lessons').orderBy('order', descending: false).get();
      final categories = <Map<String, dynamic>>[];
      for (final doc in catsSnap.docs) {
        final itemsSnap = await doc.reference.collection('items').orderBy('order', descending: false).get();
        final items = itemsSnap.docs.map((d) => {...d.data()}).toList();
        categories.add({
          'id': doc.id,
          ...doc.data(),
          'items': items,
        });
      }
      return {'categories': categories};
    } catch (_) {
      return null;
    }
  }

  String _fmt(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
