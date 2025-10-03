import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/streak_service.dart';
import '../../services/progress_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _streakService = StreakService();
  final _progress = ProgressService.instance;
  int _streak = 0;
  int _xp = 0;
  List<String> _badges = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final streak = await _streakService.getStreak();
    setState(() {
      _streak = streak;
      _xp = _progress.getXp();
      _badges = _progress.getBadges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 4, // share index with Settings for now
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              Chip(label: Text('Streak: $_streak 🔥')),
              Chip(label: Text('XP: $_xp')),
              const Chip(label: Text('Premium: Free')),
            ]),
            const SizedBox(height: 16),
            Text('Badges', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            if (_badges.isEmpty) const Text('No badges yet. Keep learning!'),
            if (_badges.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _badges.map((b) => Chip(label: Text(b))).toList(),
              ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: _load,
                child: const Text('Refresh'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
