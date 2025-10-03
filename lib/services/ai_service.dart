import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'app_config.dart';

class AiScoreResult {
  final int score; // 0-100
  final String feedback;
  AiScoreResult({required this.score, required this.feedback});
}

class AiService {
  Future<AiScoreResult> scorePronunciation({required String expectedText, required String audioPath}) async {
    // If AI endpoint configured, call it; otherwise mock.
    if (AppConfig.aiEndpoint.isNotEmpty) {
      try {
        final file = File(audioPath);
        final bytes = await file.readAsBytes();
        final payload = json.encode({
          'expectedText': expectedText,
          'audioBase64': base64Encode(bytes),
          'mimeType': 'audio/aac',
        });
        final resp = await http.post(
          Uri.parse(AppConfig.aiEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: payload,
        );
        if (resp.statusCode == 200) {
          final data = json.decode(resp.body) as Map<String, dynamic>;
          final score = (data['score'] as num?)?.toInt() ?? 0;
          final feedback = data['feedback'] as String? ?? 'No feedback';
          return AiScoreResult(score: score.clamp(0, 100), feedback: feedback);
        }
      } catch (_) {
        // fall through to mock
      }
    }

    // Mock fallback
    try {
      final file = File(audioPath);
      final bytes = await file.readAsBytes();
      final len = bytes.length;
      final base = (len % 100);
      final score = (50 + (base ~/ 2)).clamp(0, 100);
      return AiScoreResult(
        score: score,
        feedback: score > 75
            ? 'Good clarity. Work on stress patterns.'
            : 'Try speaking slower and enunciate each word.',
      );
    } catch (_) {
      return AiScoreResult(score: 0, feedback: 'Could not read recording.');
    }
  }
}
