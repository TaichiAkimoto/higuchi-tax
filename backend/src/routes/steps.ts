import { Router, Request, Response } from 'express';
import { authenticateUser } from '../middleware/auth';
import { generateMicroSteps } from '../services/gemini';

const router = Router();

router.post('/', authenticateUser, async (req: Request, res: Response) => {
  try {
    const { task } = req.body;

    // バリデーション: 型チェック
    if (task !== undefined && typeof task !== 'string') {
      return res.status(400).json({ error: 'taskは文字列である必要があります' });
    }

    // バリデーション: 必須チェック
    if (!task || task.trim() === '') {
      return res.status(400).json({ error: 'taskフィールドが必要です' });
    }

    // タスク分解
    const result = await generateMicroSteps(task);
    res.json(result);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : 'サーバーエラーが発生しました';
    res.status(400).json({ error: errorMessage });
  }
});

export default router;
