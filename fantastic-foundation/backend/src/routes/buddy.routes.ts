// backend/src/routes/buddy.routes.ts
import { Router } from 'express';
import { requireAuth, AuthRequest } from '../middleware/auth.middleware';
import {
  sendBuddyRequest,
  getIncomingRequests,
  respondToRequest,
  listBuddies
} from '../models/buddy.model';

const router = Router();

// All buddy routes are protected
router.use(requireAuth);

// POST /api/buddies/request
router.post('/request', async (req: AuthRequest, res) => {
  try {
    const { email } = req.body as { email: string };
    const br = await sendBuddyRequest(req.userId!, email);
    res.json(br);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// GET /api/buddies/requests
router.get('/requests', async (req: AuthRequest, res) => {
  const list = await getIncomingRequests(req.userId!);
  res.json(list);
});

// POST /api/buddies/respond
router.post('/respond', async (req: AuthRequest, res) => {
  const { requesterId, accept } = req.body as {
    requesterId: number;
    accept: boolean;
  };
  try {
    await respondToRequest(req.userId!, requesterId, accept);
    res.sendStatus(204);
  } catch (err: any) {
    res.status(400).json({ error: err.message });
  }
});

// GET /api/buddies
router.get('/', async (req: AuthRequest, res) => {
  const buddies = await listBuddies(req.userId!);
  res.json(buddies);
});

export default router;
