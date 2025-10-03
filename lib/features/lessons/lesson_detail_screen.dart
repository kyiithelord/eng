import 'dart:convert';
import 'package:flutter/material.dart';

import '../../services/cache_service.dart';
import '../../services/progress_service.dart';

class LessonDetailScreen extends StatefulWidget {
  final String categoryId;
  final String title;
  const LessonDetailScreen({super.key, required this.categoryId, required this.title});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  final _cache = CacheService();
  final _progress = ProgressService.instance;
  List<Map<String, dynamic>> _items = const [];
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _cache.loadLessons(assetPath: 'assets/lessons/sample_lessons.json');
    final cats = (data['categories'] as List).cast<Map<String, dynamic>>();
    final cat = cats.firstWhere((c) => c['id'] == widget.categoryId, orElse: () => {});
    final items = (cat['items'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
    setState(() => _items = items);
  }

  Future<void> _completeCurrent() async {
    if (_items.isEmpty) return;
    final id = '${widget.categoryId}-${_index}';
    await _progress.markItemCompleted(id, xp: 5);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('+5 XP')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (i) => setState(() => _index = i),
                    itemCount: _items.length,
                    itemBuilder: (context, i) {
                      final it = _items[i];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(it['text'] ?? '-', style: Theme.of(context).textTheme.headlineSmall),
                                const SizedBox(height: 8),
                                Text(it['translation_my'] ?? '-', style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 12),
                                Text(it['example'] ?? (it['examples'] != null ? (it['examples'] as List).join('\n') : '')),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item ${_index + 1}/${_items.length}'),
                      ElevatedButton.icon(
                        onPressed: _completeCurrent,
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark Done (+5 XP)'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
