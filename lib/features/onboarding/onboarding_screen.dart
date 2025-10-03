import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _lang = 'en';

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ui_language', _lang);
    await prefs.setBool('onboarded', true);
    if (!mounted) return;
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to EngApp', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              const Text('Choose your UI language'),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _lang,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'my', child: Text('Burmese')),
                ],
                onChanged: (v) => setState(() => _lang = v ?? 'en'),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _finish,
                  child: const Text('Continue'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
