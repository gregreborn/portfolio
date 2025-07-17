import pool from '../config/db';

export interface User {
  id: number;
  email: string;
  password_hash: string;
  display_name: string;
  photo_url: string | null;
  created_at: Date;
}

export async function getAllUsers(): Promise<User[]> {
  const { rows } = await pool.query<User>('SELECT * FROM users ORDER BY id');
  return rows;
}
