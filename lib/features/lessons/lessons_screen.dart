import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/cache_service.dart';
import '../../services/firebase_service.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({super.key});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  final _cache = CacheService();
  List<Map<String, dynamic>> _categories = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    Map<String, dynamic>? data = await FirebaseService.instance.fetchLessons();
    data ??= await _cache.loadLessons(assetPath: 'assets/lessons/sample_lessons.json');
    final cats = (data['categories'] as List).cast<Map<String, dynamic>>();
    setState(() {
      _categories = cats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 1,
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                final title = cat['title'] as String? ?? 'Category';
                final items = (cat['items'] as List?) ?? const [];
                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(title),
                  subtitle: Text('${items.length} items'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Open "$title" (${items.length} items) – placeholder')),
                  ),
                );
              },
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemCount: _categories.length,
            ),
    );
  }
}
