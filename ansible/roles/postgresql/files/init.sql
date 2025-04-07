CREATE DATABASE devopsdb;
\c devopsdb;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

INSERT INTO users (name) VALUES ('Joanne'), ('Abimbola'), ('Paul');
ON CONFLICT (name) DO NOTHING;