import { initializeFirebase, verifyIdToken, resetFirebase } from '../../src/services/firebase';
import * as admin from 'firebase-admin';

// Firebase Admin SDKをモック化
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  credential: {
    cert: jest.fn()
  },
  auth: jest.fn(() => ({
    verifyIdToken: jest.fn()
  }))
}));

describe('Firebase Service', () => {
  let originalEnv: NodeJS.ProcessEnv;

  beforeEach(() => {
    jest.clearAllMocks();
    // 環境変数をバックアップ
    originalEnv = { ...process.env };
    // Firebaseの初期化状態をリセット
    resetFirebase();
  });

  afterEach(() => {
    // 環境変数を復元
    process.env = originalEnv;
  });

  describe('initializeFirebase', () => {
    it('環境変数からFirebaseを初期化する', () => {
      process.env.FIREBASE_PROJECT_ID = 'test-project';
      process.env.FIREBASE_CLIENT_EMAIL = 'test@example.com';
      process.env.FIREBASE_PRIVATE_KEY = '-----BEGIN PRIVATE KEY-----\\ntest\\n-----END PRIVATE KEY-----\\n';

      initializeFirebase();

      expect(admin.credential.cert).toHaveBeenCalledWith({
        projectId: 'test-project',
        clientEmail: 'test@example.com',
        privateKey: '-----BEGIN PRIVATE KEY-----\ntest\n-----END PRIVATE KEY-----\n'
      });
      expect(admin.initializeApp).toHaveBeenCalled();
    });

    it('環境変数が不足している場合はエラーを投げる', () => {
      delete process.env.FIREBASE_PROJECT_ID;
      delete process.env.FIREBASE_CLIENT_EMAIL;
      delete process.env.FIREBASE_PRIVATE_KEY;

      expect(() => initializeFirebase()).toThrow('Firebase環境変数が設定されていません');
    });
  });

  describe('verifyIdToken', () => {
    it('有効なトークンを検証してデコード結果を返す', async () => {
      const mockDecodedToken = {
        uid: 'test-uid-123',
        email: undefined,
        aud: 'test-project',
        iat: 1234567890,
        exp: 1234567890 + 3600,
        iss: 'https://securetoken.google.com/test-project'
      };

      const mockAuth = {
        verifyIdToken: jest.fn().mockResolvedValue(mockDecodedToken)
      };
      (admin.auth as jest.Mock).mockReturnValue(mockAuth);

      const token = 'valid-test-token';
      const result = await verifyIdToken(token);

      expect(result).toEqual(mockDecodedToken);
      expect(mockAuth.verifyIdToken).toHaveBeenCalledWith(token);
    });

    it('無効なトークンの場合はエラーを投げる', async () => {
      const mockAuth = {
        verifyIdToken: jest.fn().mockRejectedValue(new Error('Invalid token'))
      };
      (admin.auth as jest.Mock).mockReturnValue(mockAuth);

      const token = 'invalid-token';

      await expect(verifyIdToken(token)).rejects.toThrow('Invalid token');
    });

    it('期限切れトークンの場合はエラーを投げる', async () => {
      const mockAuth = {
        verifyIdToken: jest.fn().mockRejectedValue(new Error('Token expired'))
      };
      (admin.auth as jest.Mock).mockReturnValue(mockAuth);

      const token = 'expired-token';

      await expect(verifyIdToken(token)).rejects.toThrow('Token expired');
    });
  });
});
