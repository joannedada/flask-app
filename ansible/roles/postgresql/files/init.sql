CREATE DATABASE devopsdb;
\c devopsdb;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');
ON CONFLICT (name) DO NOTHING;