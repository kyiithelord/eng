import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentIndex: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Go Premium', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('• Remove ads\n• Unlock full lessons\n• Enhanced AI feedback'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Purchase (placeholder)'))),
              child: const Text('Upgrade'),
            ),
          ],
        ),
      ),
    );
  }
}
