import 'package:shared_preferences/shared_preferences.dart';

class StreakService {
  static const _streakKey = 'streak_count';
  static const _lastActiveKey = 'last_active_date'; // yyyy-MM-dd

  Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
    }

  Future<int> incrementIfNewDay(DateTime now) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _fmt(now);
    final last = prefs.getString(_lastActiveKey);

    int streak = prefs.getInt(_streakKey) ?? 0;

    if (last == today) {
      return streak; // already counted today
    }

    if (last == null) {
      streak = 1;
    } else {
      final yesterday = _fmt(now.subtract(const Duration(days: 1)));
      if (last == yesterday) {
        streak += 1;
      } else {
        streak = 1; // reset
      }
    }

    await prefs.setString(_lastActiveKey, today);
    await prefs.setInt(_streakKey, streak);
    return streak;
  }

  String _fmt(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
