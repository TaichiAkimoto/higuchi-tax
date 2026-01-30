import { Request, Response, NextFunction } from 'express';
import { verifyIdToken } from '../services/firebase';

// Requestにuserプロパティを追加する型定義
declare global {
  namespace Express {
    interface Request {
      user?: {
        uid: string;
      };
    }
  }
}

export async function authenticateUser(
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({ error: 'Unauthorized' });
      return;
    }

    const token = authHeader.split('Bearer ')[1];

    try {
      const decodedToken = await verifyIdToken(token);
      req.user = { uid: decodedToken.uid };
      next();
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Invalid token';
      res.status(401).json({ error: errorMessage });
    }
  } catch (error) {
    res.status(401).json({ error: 'Unauthorized' });
  }
}
