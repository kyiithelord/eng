import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

class CacheService {
  final Box _daily = Hive.box('daily_cache');
  final Box _lessons = Hive.box('lessons_cache');

  Future<Map<String, dynamic>> loadTodayDailyWord({required String assetPath}) async {
    final today = _fmt(DateTime.now());
    final cached = _daily.get(today) as String?;
    if (cached != null) {
      return json.decode(cached) as Map<String, dynamic>;
    }
    final jsonStr = await rootBundle.loadString(assetPath);
    await _daily.put(today, jsonStr);
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> loadLessons({required String assetPath, String versionKey = 'v1'}) async {
    final cached = _lessons.get(versionKey) as String?;
    if (cached != null) {
      return json.decode(cached) as Map<String, dynamic>;
    }
    final jsonStr = await rootBundle.loadString(assetPath);
    await _lessons.put(versionKey, jsonStr);
    return json.decode(jsonStr) as Map<String, dynamic>;
  }

  String _fmt(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
