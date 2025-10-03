import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_config.dart';

class GrammarResult {
  final String corrected;
  final List<String> suggestions;
  GrammarResult({required this.corrected, required this.suggestions});
}

class GrammarService {
  Future<GrammarResult> check(String text) async {
    if (AppConfig.grammarEndpoint.isNotEmpty) {
      try {
        final resp = await http.post(
          Uri.parse(AppConfig.grammarEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'text': text}),
        );
        if (resp.statusCode == 200) {
          final data = json.decode(resp.body) as Map<String, dynamic>;
          final corrected = data['corrected'] as String? ?? text;
          final suggestions = ((data['suggestions'] as List?) ?? const []).cast<String>();
          return GrammarResult(corrected: corrected, suggestions: suggestions);
        }
      } catch (_) {
        // fall through to mock
      }
    }
    // Mock fallback: basic capitalization and simple tip
    final corrected = text.isEmpty ? text : (text[0].toUpperCase() + text.substring(1));
    final suggestions = <String>[];
    if (!text.trim().endsWith('.')) {
      suggestions.add('End sentences with a period.');
    }
    return GrammarResult(corrected: corrected, suggestions: suggestions);
  }
}
