PRAGMA foreign_keys=ON;

CREATE TABLE survey (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  start DATE,
  stop DATE
);

CREATE TABLE page (
  id INTEGER PRIMARY KEY,
  number INTEGER NOT NULL,
  survey_id INTEGER REFERENCES survey(id),
  UNIQUE (number, survey_id)
);

CREATE TABLE block (
  id INTEGER PRIMARY KEY,
  type TEXT NOT NULL,
  text TEXT NOT NULL,
  required BOOLEAN NOT NULL,
  number INTEGER NOT NULL,
  page_id INTEGER REFERENCES page(id),
  UNIQUE (number, page_id),
  CHECK (type IN ('html', 'radio', 'checkbox', 'textarea', 'range'))
);

CREATE TABLE choice (
  id INTEGER PRIMARY KEY,
  value TEXT NOT NULL,
  number INTEGER NOT NULL,
  block_id INTEGER REFERENCES block(id),
  UNIQUE (number, block_id)
);

CREATE TABLE answer (
  id INTEGER PRIMARY KEY,
  user TEXT NOT NULL,
  value TEXT NOT NULL,
  block_id INTEGER REFERENCES block(id),
  UNIQUE (user, value, block_id)
);
