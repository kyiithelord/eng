import * as functions from 'firebase-functions';
import * as express from 'express';
import * as cors from 'cors';

// Simple WER/CER-like scoring helpers (very naive)
function normalize(s: string) {
  return s.toLowerCase().replace(/[^a-z\s]/g, '').trim().replace(/\s+/g, ' ');
}

function wordErrorRate(ref: string, hyp: string): number {
  const r = normalize(ref).split(' ');
  const h = normalize(hyp).split(' ');
  const R = r.length;
  const H = h.length;
  const dp: number[][] = Array.from({ length: R + 1 }, () => Array(H + 1).fill(0));
  for (let i = 0; i <= R; i++) dp[i][0] = i;
  for (let j = 0; j <= H; j++) dp[0][j] = j;
  for (let i = 1; i <= R; i++) {
    for (let j = 1; j <= H; j++) {
      const cost = r[i - 1] === h[j - 1] ? 0 : 1;
      dp[i][j] = Math.min(
        dp[i - 1][j] + 1,
        dp[i][j - 1] + 1,
        dp[i - 1][j - 1] + cost,
      );
    }
  }
  const edits = dp[R][H];
  return R === 0 ? 0 : edits / R;
}

const app = express();
app.use(cors({ origin: true }));
app.use(express.json({ limit: '10mb' }));

// POST /aiPronunciation
// Body: { expectedText: string, audioBase64: string, mimeType: string }
app.post('/aiPronunciation', async (req, res) => {
  try {
    const { expectedText, audioBase64, mimeType } = req.body || {};
    if (!expectedText || !audioBase64) {
      return res.status(400).json({ error: 'expectedText and audioBase64 required' });
    }

    // TODO: Send audio to Whisper API, get transcription `hypothesis`.
    // For now, return a mocked hypothesis to demonstrate flow.
    const hypothesis = expectedText; // pretend perfect transcription

    const wer = wordErrorRate(expectedText, hypothesis);
    const rawScore = Math.max(0, Math.min(100, Math.round((1 - wer) * 100)));

    const feedback = rawScore > 80
      ? 'Great! Focus on natural rhythm.'
      : rawScore > 60
      ? 'Good start. Enunciate clearly and slow down a bit.'
      : 'Practice the phrase word by word and repeat slowly.';

    return res.json({ score: rawScore, feedback, wer });
  } catch (e: any) {
    console.error(e);
    return res.status(500).json({ error: 'internal_error' });
  }
});

exports.api = functions.https.onRequest(app);
