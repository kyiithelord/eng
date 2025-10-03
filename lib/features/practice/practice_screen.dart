import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../../widgets/app_scaffold.dart';
import '../../services/ai_service.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final _record = AudioRecorder();
  bool _isRecording = false;
  String _expected = 'Nice to meet you';
  int? _score;
  String? _feedback;

  @override
  void dispose() {
    _record.dispose();
    super.dispose();
  }

  Future<void> _toggleRecord() async {
    try {
      if (_isRecording) {
        final path = await _record.stop();
        setState(() => _isRecording = false);
        if (path != null) {
          final result = await AiService().scorePronunciation(expectedText: _expected, audioPath: path);
          setState(() {
            _score = result.score;
            _feedback = result.feedback;
          });
        }
      } else {
        final hasPerm = await _record.hasPermission();
        if (!hasPerm) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Microphone permission denied')));
          return;
        }
        // Provide a required recording path
        String recPath;
        if (kIsWeb) {
          // Web ignores the actual path but parameter is required
          recPath = 'web_record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        } else {
          final dir = await getTemporaryDirectory();
          recPath = '${dir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';
        }
        await _record.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: recPath);
        setState(() {
          _isRecording = true;
          _score = null;
          _feedback = null;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recording error: $e')));
    }
  }

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
            Text('Say the phrase: "$_expected"'),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleRecord,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(_isRecording ? 'Stop' : 'Record'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Score: ${_score?.toString() ?? '--'}'),
            const SizedBox(height: 8),
            Text('Feedback: ${_feedback ?? '(will appear here)'}'),
          ],
        ),
      ),
    );
  }
}
