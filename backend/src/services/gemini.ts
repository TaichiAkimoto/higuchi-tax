import { GoogleGenAI } from '@google/genai';
import { StepsResponse, MicroStep } from '../types';

// 汎用フォールバックステップ（Phase 0で設計）
const FALLBACK_STEPS: MicroStep[] = [
  { id: 'step_1', label: '1. 立ち上がる', description: '物理的に体を動かす', emoji: '🧍' },
  { id: 'step_2', label: '2. やる場所に行く', description: '対象のそばに立つ', emoji: '🚶' },
  { id: 'step_3', label: '3. 対象に触れる', description: '手に取るだけでOK', emoji: '✋' },
  { id: 'step_4', label: '4. 必要な道具を用意', description: '準備を整える', emoji: '🔧' },
  { id: 'step_5', label: '5. 最初の1分だけやる', description: 'ほんの少しだけ', emoji: '⚡' },
  { id: 'step_6', label: '6. 完了', description: 'やり切った！', emoji: '🎉' }
];

// 危険行為・違法行為のキーワードリスト
const DANGEROUS_KEYWORDS = [
  '飛び降り', '切りつけ', '襲撃', '盗む', '傷つける',
  '殺す', '破壊', '燃やす', '爆発', '暴力'
];

export async function generateMicroSteps(task: string): Promise<StepsResponse> {
  // バリデーション
  if (!task || task.trim() === '') {
    throw new Error('タスクを入力してください');
  }

  if (task.length > 200) {
    throw new Error('タスクは200文字以内にしてください');
  }

  // 安全フィルター
  const containsDangerous = DANGEROUS_KEYWORDS.some(keyword => task.includes(keyword));
  if (containsDangerous) {
    throw new Error('不適切なタスクが検出されました');
  }

  try {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      console.warn('GEMINI_API_KEY not set, using fallback steps');
      return { steps: FALLBACK_STEPS };
    }

    const ai = new GoogleGenAI({ apiKey });

    const prompt = `あなたは認知的負担を減らす専門家です。
ユーザーは「${task}」というタスクに対して動けなくなっています。

このタスクを以下の条件で分解してください:

【条件】
1. 4〜6個のステップに分解（多すぎない）
2. 第1ステップは必ず物理的な動作（「立ち上がる」「椅子を引く」「体を動かす」など）
3. 各ステップは5秒〜30秒で完了できる超具体的な行動
4. 最終ステップでタスクが完了する
5. 各ステップに適切な絵文字を付ける

【出力形式】
JSON配列のみ出力（マークダウン不要）:
[
  {"label": "1. 椅子から立ち上がる", "description": "まずは物理的に体を動かそう", "emoji": "🧍"},
  {"label": "2. ...", "description": "...", "emoji": "..."}
]

【注意】
- 危険行為や違法行為は含めない
- 心理的ハードルを極限まで下げる
- 「できなくても大丈夫」という優しい視点`;

    const response = await ai.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: prompt
    });

    const text = response.text;
    if (!text) {
      console.warn('Empty response from Gemini, using fallback');
      return { steps: FALLBACK_STEPS };
    }

    // JSONをパース（マークダウンで囲まれている場合を考慮）
    const jsonMatch = text.match(/\[[\s\S]*?\]/);
    if (!jsonMatch) {
      console.warn('Failed to parse JSON from Gemini response, using fallback');
      return { steps: FALLBACK_STEPS };
    }

    const parsedSteps = JSON.parse(jsonMatch[0]);

    // IDを追加
    const steps: MicroStep[] = parsedSteps.map((step: any, index: number) => ({
      id: `step_${index + 1}`,
      label: step.label,
      description: step.description,
      emoji: step.emoji
    }));

    // ステップ数のバリデーション
    if (steps.length < 4 || steps.length > 6) {
      console.warn('Invalid step count from Gemini, using fallback');
      return { steps: FALLBACK_STEPS };
    }

    return { steps };
  } catch (error) {
    console.error('Error generating micro steps:', error);
    return { steps: FALLBACK_STEPS };
  }
}

export async function getEncouragement(context: string): Promise<string> {
  // バリデーション
  if (!context || context.trim() === '') {
    throw new Error('状況を入力してください');
  }

  try {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey) {
      return '大丈夫。あなたのペースで、少しずつやってみよう。';
    }

    const ai = new GoogleGenAI({ apiKey });

    const prompt = `あなたは優しくて共感力の高いサポーターです。
ユーザーは些細なタスクに対して、認知的な負担を感じて動けなくなっています。

以下のユーザーの状況に対して、短く、温かく、そして「ハードルを極限まで下げる」ような励ましの言葉を送ってください。

ユーザーの状況: ${context}

制約：
- 2文以内
- 「〜しなきゃダメ」という表現は避ける
- 「〜するだけで十分えらい」というニュアンスを含める
- ネガティブな言葉（「できない」「無理」など）は使わない`;

    const response = await ai.models.generateContent({
      model: 'gemini-3-flash-preview',
      contents: prompt
    });

    return response.text || '大丈夫、一歩ずつ進んでいこう。';
  } catch (error) {
    console.error('Error getting encouragement:', error);
    return '大丈夫。あなたのペースで、少しずつやってみよう。';
  }
}
