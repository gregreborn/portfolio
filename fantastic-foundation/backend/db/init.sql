CREATE TABLE IF NOT EXISTS users (
  id            SERIAL PRIMARY KEY,
  email         TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  display_name  TEXT NOT NULL,
  photo_url     TEXT,
  created_at    TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS buddies (
  user_id   INT REFERENCES users(id),
  buddy_id  INT REFERENCES users(id),
  status    TEXT CHECK (status IN ('pending','accepted','rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, buddy_id)
);

CREATE TABLE IF NOT EXISTS checkins (
  id            SERIAL PRIMARY KEY,
  user_id       INT REFERENCES users(id),
  checked_in_at TIMESTAMP NOT NULL DEFAULT now()
);
