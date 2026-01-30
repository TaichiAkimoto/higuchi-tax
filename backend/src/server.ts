import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import stepsRouter from './routes/steps';
import encourageRouter from './routes/encourage';
import { initializeFirebase } from './services/firebase';

// 環境変数を読み込み
dotenv.config();

// Firebaseを初期化
try {
  initializeFirebase();
  console.log('✅ Firebase initialized successfully');
} catch (error) {
  console.error('⚠️  Firebase initialization failed:', error);
  console.log('   Continuing without Firebase auth (for local development)');
}

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/steps', stepsRouter);
app.use('/api/encourage', encourageRouter);

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error('Server error:', err);
  res.status(500).json({ error: 'Internal server error' });
});

// Start server
if (process.env.NODE_ENV !== 'test') {
  app.listen(PORT, () => {
    console.log(`🚀 Server running on port ${PORT}`);
    console.log(`   Health check: http://localhost:${PORT}/health`);
    console.log(`   API endpoints:`);
    console.log(`     POST /api/steps`);
    console.log(`     POST /api/encourage`);
  });
}

export default app;
