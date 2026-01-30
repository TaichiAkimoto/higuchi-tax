import { Request, Response, NextFunction } from 'express';
import { authenticateUser } from '../../src/middleware/auth';
import * as firebaseService from '../../src/services/firebase';

// Firebase serviceをモック化
jest.mock('../../src/services/firebase');

describe('Authentication Middleware', () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let nextFunction: NextFunction;

  beforeEach(() => {
    mockRequest = {
      headers: {}
    };
    mockResponse = {
      status: jest.fn().mockReturnThis(),
      json: jest.fn()
    };
    nextFunction = jest.fn();
    jest.clearAllMocks();
  });

  describe('authenticateUser', () => {
    it('有効なトークンの場合、req.userにuidを設定してnextを呼ぶ', async () => {
      const mockDecodedToken = {
        uid: 'test-uid-123',
        aud: 'test-project',
        iat: 1234567890,
        exp: 1234567890 + 3600,
        iss: 'https://securetoken.google.com/test-project'
      };

      (firebaseService.verifyIdToken as jest.Mock).mockResolvedValue(mockDecodedToken);
      mockRequest.headers = {
        authorization: 'Bearer valid-token-123'
      };

      await authenticateUser(
        mockRequest as Request,
        mockResponse as Response,
        nextFunction
      );

      expect(firebaseService.verifyIdToken).toHaveBeenCalledWith('valid-token-123');
      expect((mockRequest as any).user).toEqual({ uid: 'test-uid-123' });
      expect(nextFunction).toHaveBeenCalled();
      expect(mockResponse.status).not.toHaveBeenCalled();
    });

    it('Authorizationヘッダーがない場合、401を返す', async () => {
      mockRequest.headers = {};

      await authenticateUser(
        mockRequest as Request,
        mockResponse as Response,
        nextFunction
      );

      expect(firebaseService.verifyIdToken).not.toHaveBeenCalled();
      expect(mockResponse.status).toHaveBeenCalledWith(401);
      expect(mockResponse.json).toHaveBeenCalledWith({ error: 'Unauthorized' });
      expect(nextFunction).not.toHaveBeenCalled();
    });

    it('Bearer形式でない場合、401を返す', async () => {
      mockRequest.headers = {
        authorization: 'Basic invalid-format'
      };

      await authenticateUser(
        mockRequest as Request,
        mockResponse as Response,
        nextFunction
      );

      expect(mockResponse.status).toHaveBeenCalledWith(401);
      expect(mockResponse.json).toHaveBeenCalledWith({ error: 'Unauthorized' });
      expect(nextFunction).not.toHaveBeenCalled();
    });

    it('無効なトークンの場合、401を返す', async () => {
      (firebaseService.verifyIdToken as jest.Mock).mockRejectedValue(new Error('Invalid token'));
      mockRequest.headers = {
        authorization: 'Bearer invalid-token'
      };

      await authenticateUser(
        mockRequest as Request,
        mockResponse as Response,
        nextFunction
      );

      expect(firebaseService.verifyIdToken).toHaveBeenCalledWith('invalid-token');
      expect(mockResponse.status).toHaveBeenCalledWith(401);
      expect(mockResponse.json).toHaveBeenCalledWith({ error: 'Invalid token' });
      expect(nextFunction).not.toHaveBeenCalled();
    });

    it('期限切れトークンの場合、401を返す', async () => {
      (firebaseService.verifyIdToken as jest.Mock).mockRejectedValue(new Error('Token expired'));
      mockRequest.headers = {
        authorization: 'Bearer expired-token'
      };

      await authenticateUser(
        mockRequest as Request,
        mockResponse as Response,
        nextFunction
      );

      expect(mockResponse.status).toHaveBeenCalledWith(401);
      expect(mockResponse.json).toHaveBeenCalledWith({ error: 'Token expired' });
      expect(nextFunction).not.toHaveBeenCalled();
    });
  });
});
