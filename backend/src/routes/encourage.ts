import { Router, Request, Response } from 'express';
import { authenticateUser } from '../middleware/auth';
import { getEncouragement } from '../services/gemini';

const router = Router();

router.post('/', authenticateUser, async (req: Request, res: Response) => {
  try {
    const { context } = req.body;

    // バリデーション: 型チェック
    if (context !== undefined && typeof context !== 'string') {
      return res.status(400).json({ error: 'contextは文字列である必要があります' });
    }

    // バリデーション: 必須チェック
    if (!context || context.trim() === '') {
      return res.status(400).json({ error: 'contextフィールドが必要です' });
    }

    // 励ましメッセージ生成
    const message = await getEncouragement(context);
    res.json({ message });
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'サーバーエラーが発生しました';
    res.status(500).json({ error: errorMessage });
  }
});

export default router;
