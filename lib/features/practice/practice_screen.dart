import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pronunciation Practice', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Say the phrase: "Nice to meet you"'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Record (placeholder)'))),
                  icon: const Icon(Icons.mic),
                  label: const Text('Record'),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Submit (placeholder)'))),
                  icon: const Icon(Icons.send),
                  label: const Text('Submit'),
                )
              ],
            ),
            const SizedBox(height: 24),
            const Text('Score: --'),
            const SizedBox(height: 8),
            const Text('Feedback: (will appear here)')
          ],
        ),
      ),
    );
  }
}
