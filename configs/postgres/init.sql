CREATE SCHEMA IF NOT EXISTS de_scala;

CREATE TYPE de_scala.person_level AS ENUM ('jun', 'middle', 'senior', 'lead');

CREATE TYPE de_scala.person_evaluation AS ENUM ('A', 'B', 'C', 'D', 'E');
CREATE TYPE de_scala.person_quarter AS ENUM ('I', 'II', 'III', 'IV');

CREATE TABLE IF NOT EXISTS de_scala.staff(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name TEXT NOT NULL,
    birthdate DATE,
    start_date DATE NOT NULL,
    position TEXT NOT NULL,
    level de_scala.person_level NOT NULL,
    salary FLOAT,
    department uuid NOT NULL,
    access boolean DEFAULT FALSE,
    created_at timestamptz DEFAULT NOW(),
    updated_at timestamptz DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS de_scala.department(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL UNIQUE,
    director TEXT NOT NULL, -- Здесь не должно этого быть
    amount int DEFAULT 0
);

CREATE TABLE IF NOT EXISTS de_scala.evaluation(
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    evaluation de_scala.person_evaluation
);

CREATE TABLE IF NOT EXISTS de_scala.staff_evaluation (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_id uuid NOT NULL,
    evaluation_id uuid NOT NULL,
    quarter de_scala.person_quarter,
    created_at timestamptz DEFAULT NOW()
);

CREATE UNIQUE INDEX if not exists evaluation_staff ON de_scala.staff_evaluation (staff_id, evaluation_id, quarter);
