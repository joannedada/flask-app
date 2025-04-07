CREATE DATABASE devopsdb;
\c devopsdb;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    role VARCHAR(50)
);

INSERT INTO users (name, role)
VALUES
('Joanne Obodoagwu', 'DevOps Engineer'),
('Abimbola Joshua', 'DevSecOps Engineer'),
('Paul Ikpi', 'Solutions Architect')
ON CONFLICT (name) DO NOTHING;