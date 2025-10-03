import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/cache_service.dart';
import '../../services/progress_service.dart';

class QuizScreen extends StatefulWidget {
  final String categoryId;
  final String title;
  const QuizScreen({super.key, required this.categoryId, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _cache = CacheService();
  final _progress = ProgressService.instance;
  List<Map<String, dynamic>> _items = const [];
  int _qIndex = 0;
  int _correct = 0;
  List<_Question> _questions = const [];
  bool _done = false;

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
    _items = items;
    _questions = _buildQuestions(items, count: 5);
    setState(() {});
  }

  List<_Question> _buildQuestions(List<Map<String, dynamic>> items, {int count = 5}) {
    final rnd = Random();
    final qs = <_Question>[];
    final pool = List<Map<String, dynamic>>.from(items);
    pool.shuffle(rnd);
    final take = pool.take(count.clamp(1, pool.length)).toList();
    for (final it in take) {
      final correct = (it['translation_my'] ?? '').toString();
      final others = items.where((e) => !identical(e, it)).map((e) => (e['translation_my'] ?? '').toString()).toList();
      others.shuffle(rnd);
      final options = <String>{correct, ...others.take(3)}.toList();
      options.shuffle(rnd);
      qs.add(_Question(prompt: (it['text'] ?? '').toString(), options: options, answer: correct));
    }
    return qs;
  }

  void _selectOption(String opt) async {
    if (_done) return;
    final q = _questions[_qIndex];
    final isCorrect = opt == q.answer;
    if (isCorrect) {
      _correct += 1;
      await _progress.addXp(3);
    }
    if (_qIndex + 1 < _questions.length) {
      setState(() => _qIndex += 1);
    } else {
      setState(() => _done = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(appBar: AppBar(title: Text(widget.title)), body: const Center(child: CircularProgressIndicator()));
    }
    if (_done) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Score: $_correct / ${_questions.length}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              const Text('You earned +3 XP per correct answer.')
            ],
          ),
        ),
      );
    }
    final q = _questions[_qIndex];
    return Scaffold(
      appBar: AppBar(title: Text('${widget.title} (${_qIndex + 1}/${_questions.length})')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What is the Burmese translation for:', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(q.prompt, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            ...q.options.map((opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _selectOption(opt),
                    child: Align(alignment: Alignment.centerLeft, child: Text(opt)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _Question {
  final String prompt;
  final List<String> options;
  final String answer;
  _Question({required this.prompt, required this.options, required this.answer});
}
