import { generateMicroSteps, getEncouragement } from '../../src/services/gemini';

describe('Gemini Service - generateMicroSteps', () => {
  describe('正常系: タスク分解', () => {
    it('任意のタスクを4-6個のマイクロステップに分解する', async () => {
      const task = '封筒を開ける';
      const result = await generateMicroSteps(task);

      expect(result.steps).toBeDefined();
      expect(result.steps.length).toBeGreaterThanOrEqual(4);
      expect(result.steps.length).toBeLessThanOrEqual(6);
    });

    it('各ステップはid, label, description, emojiを含む', async () => {
      const task = 'メールを見る';
      const result = await generateMicroSteps(task);

      result.steps.forEach((step, index) => {
        expect(step.id).toBe(`step_${index + 1}`);
        expect(step.label).toMatch(/^\d+\./); // "1. " で始まる
        expect(step.description).toBeTruthy();
        expect(step.emoji).toBeTruthy(); // 絵文字が存在することをチェック
        expect(step.emoji.length).toBeGreaterThan(0);
      });
    });

    it('第1ステップは物理的な動作を含む', async () => {
      const task = '請求書を見る';
      const result = await generateMicroSteps(task);

      const firstStep = result.steps[0];
      const physicalActionKeywords = ['立', '起き', '動', '行く', '向かう', '近づく'];
      const containsPhysicalAction = physicalActionKeywords.some(
        keyword => firstStep.label.includes(keyword) || firstStep.description.includes(keyword)
      );

      expect(containsPhysicalAction).toBe(true);
    });
  });

  describe('異常系: 安全フィルター', () => {
    it('危険行為を含むタスクは拒否する', async () => {
      const dangerousTasks = [
        '高い場所から飛び降りる',
        '刃物で切りつける',
      ];

      for (const task of dangerousTasks) {
        await expect(generateMicroSteps(task)).rejects.toThrow('不適切なタスク');
      }
    });

    it('違法行為を含むタスクは拒否する', async () => {
      const illegalTask = '銀行を襲撃する';
      await expect(generateMicroSteps(illegalTask)).rejects.toThrow('不適切なタスク');
    });

    it('200文字を超えるタスクは拒否する', async () => {
      const longTask = 'あ'.repeat(201);
      await expect(generateMicroSteps(longTask)).rejects.toThrow('タスクは200文字以内');
    });

    it('空文字列のタスクは拒否する', async () => {
      await expect(generateMicroSteps('')).rejects.toThrow('タスクを入力してください');
    });
  });

  describe('フォールバック: Gemini APIエラー時', () => {
    it('API障害時は汎用ミニステップを返す', async () => {
      // Gemini APIをモック化してエラーを発生させる
      const task = 'テストタスク';

      // TODO: Gemini APIモックの実装
      // この時点では実装を先に進めてからモックを追加する
    });
  });
});

describe('Gemini Service - getEncouragement', () => {
  describe('正常系: 励ましメッセージ生成', () => {
    it('状況に応じた励ましメッセージを返す', async () => {
      const context = '封筒を開けようとしているけど、腰が重くて動けない';
      const message = await getEncouragement(context);

      expect(message).toBeTruthy();
      expect(message.length).toBeGreaterThan(0);
      expect(message.length).toBeLessThan(200); // 2文以内程度
    });

    it('ネガティブな表現を避ける', async () => {
      const context = '何もやる気が起きない';
      const message = await getEncouragement(context);

      const negativePatterns = ['ダメ', 'しなきゃ', 'できない', '無理'];
      const containsNegative = negativePatterns.some(pattern => message.includes(pattern));

      expect(containsNegative).toBe(false);
    });
  });

  describe('異常系', () => {
    it('空文字列は拒否する', async () => {
      await expect(getEncouragement('')).rejects.toThrow();
    });
  });
});
