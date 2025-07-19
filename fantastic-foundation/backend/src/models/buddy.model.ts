// backend/src/models/buddy.model.ts
import pool from '../config/db';

export type BuddyStatus = 'pending' | 'accepted' | 'rejected';

export interface Buddy {
  user_id: number;
  buddy_id: number;
  status: BuddyStatus;
  created_at: Date;
}

// 1) Send a request
export async function sendBuddyRequest(
  userId: number,
  buddyEmail: string
): Promise<Buddy> {
  // look up the buddy by email
  const userRes = await pool.query<{ id: number }>(
    'SELECT id FROM users WHERE email = $1',
    [buddyEmail]
  );
  if (userRes.rowCount === 0) {
    throw new Error('User not found');
  }
  const buddyId = userRes.rows[0].id;

  // insert a pending request
  const insertRes = await pool.query<Buddy>(
    `INSERT INTO buddies (user_id, buddy_id, status)
     VALUES ($1, $2, 'pending')
     RETURNING *`,
    [userId, buddyId]
  );
  return insertRes.rows[0];
}

// 2) List incoming (pending) requests
export async function getIncomingRequests(
  userId: number
): Promise<Buddy[]> {
  const res = await pool.query<Buddy>(
    `SELECT b.* FROM buddies b
     WHERE b.buddy_id = $1
       AND b.status = 'pending'
     ORDER BY b.created_at`,
    [userId]
  );
  return res.rows;
}

// 3) Respond to a request
export async function respondToRequest(
  userId: number,
  requesterId: number,
  accept: boolean
): Promise<void> {
  const newStatus: BuddyStatus = accept ? 'accepted' : 'rejected';
  await pool.query(
    `UPDATE buddies
     SET status = $1
     WHERE user_id = $2 AND buddy_id = $3`,
    [newStatus, requesterId, userId]
  );
  if (accept) {
    // On accept, create reciprocal accepted row
    await pool.query(
      `INSERT INTO buddies (user_id, buddy_id, status)
       VALUES ($1, $2, 'accepted')
       ON CONFLICT DO NOTHING`,
      [userId, requesterId]
    );
  }
}

// 4) List confirmed buddies
export async function listBuddies(
  userId: number
): Promise<{ id: number; display_name: string; photo_url: string | null }[]> {
  const res = await pool.query<{
    id: number;
    display_name: string;
    photo_url: string | null;
  }>(
    `SELECT u.id, u.display_name, u.photo_url
     FROM buddies b
     JOIN users u ON u.id = b.buddy_id
     WHERE b.user_id = $1
       AND b.status = 'accepted'
     ORDER BY u.display_name`,
    [userId]
  );
  return res.rows;
}
