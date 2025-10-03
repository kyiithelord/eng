import 'package:flutter/material.dart';
import '../../services/grammar_service.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  final _ctrl = TextEditingController();
  GrammarResult? _result;
  bool _loading = false;

  Future<void> _check() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _loading = true);
    final res = await GrammarService().check(text);
    setState(() {
      _result = res;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grammar Check')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _ctrl,
              minLines: 3,
              maxLines: 6,
              decoration: const InputDecoration(
                labelText: 'Enter a sentence',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _check,
              icon: const Icon(Icons.spellcheck),
              label: const Text('Check Grammar'),
            ),
            const SizedBox(height: 16),
            if (_loading) const LinearProgressIndicator(),
            if (_result != null) ...[
              Text('Corrected:', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(_result!.corrected),
              const SizedBox(height: 12),
              if (_result!.suggestions.isNotEmpty) ...[
                Text('Suggestions:', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                ..._result!.suggestions.map((s) => Text('• $s')),
              ],
            ]
          ],
        ),
      ),
    );
  }
}
