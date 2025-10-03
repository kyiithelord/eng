import 'package:flutter/material.dart';
import '../../widgets/app_scaffold.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      currentIndex: 1,
      child: _LessonsBody(),
    );
  }
}

class _LessonsBody extends StatelessWidget {
  const _LessonsBody();

  @override
  Widget build(BuildContext context) {
    final categories = const ['Greetings', 'Jobs', 'Travel', 'IELTS Tips'];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i) {
        final title = categories[i];
        return ListTile(
          leading: const Icon(Icons.menu_book),
          title: Text(title),
          subtitle: const Text('10 items · placeholder'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Open "$title" (placeholder)'))),
        );
      },
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemCount: categories.length,
    );
  }
}
