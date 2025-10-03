import 'package:hive/hive.dart';

class ProgressService {
  static final ProgressService instance = ProgressService._();
  ProgressService._();

  final Box _box = Hive.box('progress_cache');

  int getXp() => _box.get('xp', defaultValue: 0) as int;
  Future<void> addXp(int amount) async {
    final current = getXp();
    await _box.put('xp', current + amount);
  }

  Set<String> getCompletedItems() {
    final list = (_box.get('completed_items', defaultValue: <String>[]) as List).cast<String>();
    return list.toSet();
  }

  Future<void> markItemCompleted(String itemId, {int xp = 5}) async {
    final items = getCompletedItems();
    if (items.add(itemId)) {
      await _box.put('completed_items', items.toList());
      await addXp(xp);
      await _updateBadges();
    }
  }

  List<String> getBadges() => (_box.get('badges', defaultValue: <String>[]) as List).cast<String>();

  Future<void> _updateBadges() async {
    final badges = getBadges().toSet();
    final itemsCount = getCompletedItems().length;
    final xp = getXp();
    if (itemsCount >= 10) badges.add('10 Items');
    if (xp >= 100) badges.add('100 XP');
    await _box.put('badges', badges.toList());
  }

  // Daily challenge helpers
  String _fmt(DateTime dt) =>
      '${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  bool isDailyChallengeDone(DateTime now) {
    final last = _box.get('daily_challenge_date') as String?;
    return last == _fmt(now);
  }

  Future<bool> completeDailyChallenge({int xp = 10}) async {
    final today = _fmt(DateTime.now());
    final last = _box.get('daily_challenge_date') as String?;
    if (last == today) return false;
    await _box.put('daily_challenge_date', today);
    await addXp(xp);
    await _updateBadges();
    return true;
  }
}
