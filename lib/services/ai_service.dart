import 'dart:io';

class AiScoreResult {
  final int score; // 0-100
  final String feedback;
  AiScoreResult({required this.score, required this.feedback});
}

class AiService {
  // Mock scoring: compares lengths and naive overlap; replace with API call.
  Future<AiScoreResult> scorePronunciation({required String expectedText, required String audioPath}) async {
    // In a real implementation:
    // 1) Upload audio file to your Cloud Function endpoint
    // 2) Cloud Function sends to Whisper for transcription
    // 3) Compute WER/CER vs expectedText and return structured feedback
    // Here we just fake it based on file size to show UI flow.
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
