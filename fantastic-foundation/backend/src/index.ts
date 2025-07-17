import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import userRouter from './routes/user.routes';
import authRouter from './routes/auth.routes';
import { requireAuth } from './middleware/auth.middleware';

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

app.use('/auth', authRouter);

app.use('/api/users',requireAuth, userRouter);

app.get('/health', (_req, res) => {
  res.send('OK');
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`🚀 Server listening on http://localhost:${PORT}`);
});
