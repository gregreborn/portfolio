import { Router } from 'express';
import { getAllUsers } from '../models/user.model';

const router = Router();

// GET /api/users — return all users
router.get('/', async (_req, res) => {
  try {
    const users = await getAllUsers();
    res.json(users);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
});

export default router;
