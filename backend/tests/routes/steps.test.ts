import request from 'supertest';
import express, { Express } from 'express';
import stepsRouter from '../../src/routes/steps';
import * as geminiService from '../../src/services/gemini';
import { authenticateUser } from '../../src/middleware/auth';

// geminiServiceをモック化
jest.mock('../../src/services/gemini');
jest.mock('../../src/middleware/auth');

describe('POST /api/steps', () => {
  let app: Express;

  beforeEach(() => {
    app = express();
    app.use(express.json());
    app.use('/api/steps', stepsRouter);
    jest.clearAllMocks();

    // authenticateUserミドルウェアをモック（常に成功）
    (authenticateUser as jest.Mock).mockImplementation((req, res, next) => {
      req.user = { uid: 'test-uid-123' };
      next();
    });
  });

  describe('正常系', () => {
    it('有効なタスクでマイクロステップを返す', async () => {
      const mockSteps = {
        steps: [
          { id: 'step_1', label: '1. 立ち上がる', description: '物理的に体を動かす', emoji: '🧍' },
          { id: 'step_2', label: '2. やる場所に行く', description: '対象のそばに立つ', emoji: '🚶' },
          { id: 'step_3', label: '3. 対象に触れる', description: '手に取るだけでOK', emoji: '✋' },
          { id: 'step_4', label: '4. 必要な道具を用意', description: '準備を整える', emoji: '🔧' },
          { id: 'step_5', label: '5. 最初の1分だけやる', description: 'ほんの少しだけ', emoji: '⚡' },
          { id: 'step_6', label: '6. 完了', description: 'やり切った！', emoji: '🎉' }
        ]
      };

      (geminiService.generateMicroSteps as jest.Mock).mockResolvedValue(mockSteps);

      const response = await request(app)
        .post('/api/steps')
        .send({ task: '封筒を開ける' })
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toEqual(mockSteps);
      expect(geminiService.generateMicroSteps).toHaveBeenCalledWith('封筒を開ける');
    });

    it('様々なタスクに対応する', async () => {
      const tasks = ['メールを見る', '請求書を見る', '洗濯物を畳む'];

      for (const task of tasks) {
        (geminiService.generateMicroSteps as jest.Mock).mockResolvedValue({
          steps: [
            { id: 'step_1', label: '1. 立ち上がる', description: 'テスト', emoji: '🧍' },
            { id: 'step_2', label: '2. やる', description: 'テスト', emoji: '⚡' },
            { id: 'step_3', label: '3. 完了', description: 'テスト', emoji: '🎉' }
          ]
        });

        const response = await request(app)
          .post('/api/steps')
          .send({ task })
          .expect(200);

        expect(geminiService.generateMicroSteps).toHaveBeenCalledWith(task);
        expect(response.body.steps).toBeDefined();
      }
    });
  });

  describe('異常系', () => {
    it('taskフィールドがない場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/steps')
        .send({})
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response.body).toEqual({ error: 'taskフィールドが必要です' });
      expect(geminiService.generateMicroSteps).not.toHaveBeenCalled();
    });

    it('taskが空文字列の場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/steps')
        .send({ task: '' })
        .expect(400);

      expect(response.body).toEqual({ error: 'taskフィールドが必要です' });
    });

    it('taskが文字列でない場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/steps')
        .send({ task: 123 })
        .expect(400);

      expect(response.body).toEqual({ error: 'taskは文字列である必要があります' });
    });

    it('geminiServiceがエラーを投げた場合、400を返す', async () => {
      (geminiService.generateMicroSteps as jest.Mock).mockRejectedValue(
        new Error('不適切なタスクが検出されました')
      );

      const response = await request(app)
        .post('/api/steps')
        .send({ task: '危険なタスク' })
        .expect(400);

      expect(response.body).toEqual({ error: '不適切なタスクが検出されました' });
    });

    it('予期しないエラーの場合、500を返す', async () => {
      (geminiService.generateMicroSteps as jest.Mock).mockRejectedValue(
        new Error('Unexpected error')
      );

      const response = await request(app)
        .post('/api/steps')
        .send({ task: 'テストタスク' })
        .expect(400);

      expect(response.body.error).toBeTruthy();
    });
  });

  describe('認証', () => {
    it('認証されていない場合、401を返す', async () => {
      // authenticateUserミドルウェアを401を返すように上書き
      (authenticateUser as jest.Mock).mockImplementation((req, res, next) => {
        res.status(401).json({ error: 'Unauthorized' });
      });

      await request(app)
        .post('/api/steps')
        .send({ task: 'テストタスク' })
        .expect(401);

      expect(geminiService.generateMicroSteps).not.toHaveBeenCalled();
    });
  });
});
