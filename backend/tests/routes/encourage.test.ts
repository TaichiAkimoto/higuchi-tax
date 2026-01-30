import request from 'supertest';
import express, { Express } from 'express';
import encourageRouter from '../../src/routes/encourage';
import * as geminiService from '../../src/services/gemini';
import { authenticateUser } from '../../src/middleware/auth';

// geminiServiceをモック化
jest.mock('../../src/services/gemini');
jest.mock('../../src/middleware/auth');

describe('POST /api/encourage', () => {
  let app: Express;

  beforeEach(() => {
    app = express();
    app.use(express.json());
    app.use('/api/encourage', encourageRouter);
    jest.clearAllMocks();

    // authenticateUserミドルウェアをモック（常に成功）
    (authenticateUser as jest.Mock).mockImplementation((req, res, next) => {
      req.user = { uid: 'test-uid-123' };
      next();
    });
  });

  describe('正常系', () => {
    it('有効な状況で励ましメッセージを返す', async () => {
      const mockMessage = '大丈夫。開けるだけで十分えらいよ。';
      (geminiService.getEncouragement as jest.Mock).mockResolvedValue(mockMessage);

      const response = await request(app)
        .post('/api/encourage')
        .send({ context: '封筒を開けようとしているけど、腰が重くて動けない' })
        .expect('Content-Type', /json/)
        .expect(200);

      expect(response.body).toEqual({ message: mockMessage });
      expect(geminiService.getEncouragement).toHaveBeenCalledWith(
        '封筒を開けようとしているけど、腰が重くて動けない'
      );
    });

    it('様々な状況に対応する', async () => {
      const contexts = [
        'メールを見るのが怖い',
        '何もやる気が起きない',
        '疲れている'
      ];

      for (const context of contexts) {
        (geminiService.getEncouragement as jest.Mock).mockResolvedValue(
          '大丈夫、一歩ずつ進んでいこう。'
        );

        const response = await request(app)
          .post('/api/encourage')
          .send({ context })
          .expect(200);

        expect(geminiService.getEncouragement).toHaveBeenCalledWith(context);
        expect(response.body.message).toBeTruthy();
      }
    });
  });

  describe('異常系', () => {
    it('contextフィールドがない場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/encourage')
        .send({})
        .expect('Content-Type', /json/)
        .expect(400);

      expect(response.body).toEqual({ error: 'contextフィールドが必要です' });
      expect(geminiService.getEncouragement).not.toHaveBeenCalled();
    });

    it('contextが空文字列の場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/encourage')
        .send({ context: '' })
        .expect(400);

      expect(response.body).toEqual({ error: 'contextフィールドが必要です' });
    });

    it('contextが文字列でない場合、400を返す', async () => {
      const response = await request(app)
        .post('/api/encourage')
        .send({ context: 123 })
        .expect(400);

      expect(response.body).toEqual({ error: 'contextは文字列である必要があります' });
    });

    it('geminiServiceがエラーを投げた場合、500を返す', async () => {
      (geminiService.getEncouragement as jest.Mock).mockRejectedValue(
        new Error('API error')
      );

      const response = await request(app)
        .post('/api/encourage')
        .send({ context: 'テスト状況' })
        .expect(500);

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
        .post('/api/encourage')
        .send({ context: 'テスト状況' })
        .expect(401);

      expect(geminiService.getEncouragement).not.toHaveBeenCalled();
    });
  });
});
