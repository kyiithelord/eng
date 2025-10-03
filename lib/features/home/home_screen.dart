import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../services/streak_service.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/cache_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _streakService = StreakService();
  int _streak = 0;
  Map<String, dynamic>? _daily;
  final _cache = CacheService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final streak = await _streakService.incrementIfNewDay(DateTime.now());
    final data = await _cache.loadTodayDailyWord(
      assetPath: 'assets/daily/sample.json',
    );
    setState(() {
      _streak = streak;
      _daily = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 0,
      child: _daily == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('EngApp', style: Theme.of(context).textTheme.headlineMedium),
                      Chip(label: Text('Streak: $_streak 🔥')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Word', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 8),
                          Text(
                            _daily!['word'] ?? '-',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(_daily!['translation_my'] ?? '-', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(_daily!['example'] ?? ''),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.volume_up),
                                label: const Text('Play'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.download),
                                label: const Text('Save'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Quick Lessons', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: const [
                      _LessonChip(title: 'Greetings'),
                      _LessonChip(title: 'Jobs'),
                      _LessonChip(title: 'Travel'),
                      _LessonChip(title: 'IELTS Tips'),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class _LessonChip extends StatelessWidget {
  final String title;
  const _LessonChip({required this.title});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(title),
      onPressed: () => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Open "$title" (placeholder)'))),
    );
  }
}
