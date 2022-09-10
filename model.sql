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

INSERT INTO survey VALUES (NULL, 'CourtBouillon 2‑Year Anniversary Survey', '2022-09-08', '2022-10-11');

INSERT INTO page VALUES (NULL, 1, 1);
INSERT INTO block VALUES (NULL, 'html', '<p>Hello and welcome on this WeasyPrint survey!</p><p>Thank you for taking time to answer. Don’t worry, it won’t be too long 😉.</p><p>This survey will help us to improve WeasyPrint and make your experience better!</p>', false, 1, 1);

INSERT INTO page VALUES (NULL, 2, 1);
INSERT INTO block VALUES (NULL, 'radio', '<h2>Do you know what CourtBouillon is?</h2>', false, 1, 2);
INSERT INTO choice VALUES (NULL, 'Yes, you take care of WeasyPrint and other open source projects (and it’s also a broath)', 1, 2);
INSERT INTO choice VALUES (NULL, 'No (until now)', 2, 2);

INSERT INTO page VALUES (NULL, 3, 1);
INSERT INTO block VALUES (NULL, 'checkbox', '<h2>Which CourtBouillon projects do you directly use?</h2>', false, 1, 3);
INSERT INTO choice VALUES (NULL, 'WeasyPrint', 1, 3);
INSERT INTO choice VALUES (NULL, 'pydyf', 2, 3);
INSERT INTO choice VALUES (NULL, 'tinycss2', 3, 3);
INSERT INTO choice VALUES (NULL, 'Pyphen', 4, 3);
INSERT INTO block VALUES (NULL, 'textarea', '<p>Other</p>', false, 2, 3);
INSERT INTO choice VALUES (NULL, '', 1, 4);

INSERT INTO page VALUES (NULL, 4, 1);
INSERT INTO block VALUES (NULL, 'textarea', '<h2>What do you do with CourtBouillon projects</h2>', false, 1, 4);
INSERT INTO choice VALUES (NULL, '', 1, 5);

INSERT INTO page VALUES (NULL, 5, 1);
INSERT INTO block VALUES (NULL, 'radio', '<h2>Do you know that you can get professional support on CourtBouillon products?</h2>', false, 1, 5);
INSERT INTO choice VALUES (NULL, 'Yes, we already work together', 1, 6);
INSERT INTO choice VALUES (NULL, 'Yes, but I don’t have the need', 2, 6);
INSERT INTO choice VALUES (NULL, 'No, but it’s interesting to know', 3, 6);
INSERT INTO choice VALUES (NULL, 'No, and I’m not interested anyway', 4, 6);

INSERT INTO page VALUES (NULL, 6, 1);
INSERT INTO block VALUES (NULL, 'checkbox', '<h2>Which new features of this last year do you enjoy the most?</h2>', false, 1, 6);
INSERT INTO choice VALUES (NULL, 'Footnotes', 1, 7);
INSERT INTO choice VALUES (NULL, 'Smaller PDFs', 2, 7);
INSERT INTO choice VALUES (NULL, 'Faster generation', 3, 7);
INSERT INTO choice VALUES (NULL, 'PDF/A support', 4, 7);
INSERT INTO choice VALUES (NULL, 'Bitmap fonts support', 5, 7);

INSERT INTO page VALUES (NULL, 7, 1);
INSERT INTO block VALUES (NULL, 'html', '<h2>Which features would you like to see in WeasyPrint?</h2>', false, 1, 7);
INSERT INTO block VALUES (NULL, 'range', 'MathML', false, 2, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 9);
INSERT INTO choice VALUES (NULL, '2', 3, 9);
INSERT INTO choice VALUES (NULL, '3', 4, 9);
INSERT INTO choice VALUES (NULL, '4', 5, 9);
INSERT INTO block VALUES (NULL, 'range', 'Smaller PDFs', false, 3, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 10);
INSERT INTO choice VALUES (NULL, '2', 3, 10);
INSERT INTO choice VALUES (NULL, '3', 4, 10);
INSERT INTO choice VALUES (NULL, '4', 5, 10);
INSERT INTO block VALUES (NULL, 'range', 'CMYK and color profiles', false, 4, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 11);
INSERT INTO choice VALUES (NULL, '2', 3, 11);
INSERT INTO choice VALUES (NULL, '3', 4, 11);
INSERT INTO choice VALUES (NULL, '4', 5, 11);
INSERT INTO block VALUES (NULL, 'range', 'Faster generation', false, 5, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 12);
INSERT INTO choice VALUES (NULL, '2', 3, 12);
INSERT INTO choice VALUES (NULL, '3', 4, 12);
INSERT INTO choice VALUES (NULL, '4', 5, 12);
INSERT INTO block VALUES (NULL, 'range', 'Standalone executable for macOS', false, 6, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 13);
INSERT INTO choice VALUES (NULL, '2', 3, 13);
INSERT INTO choice VALUES (NULL, '3', 4, 13);
INSERT INTO choice VALUES (NULL, '4', 5, 13);
INSERT INTO block VALUES (NULL, 'range', 'Standalone executable for Windows', false, 7, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 14);
INSERT INTO choice VALUES (NULL, '2', 3, 14);
INSERT INTO choice VALUES (NULL, '3', 4, 14);
INSERT INTO choice VALUES (NULL, '4', 5, 14);
INSERT INTO block VALUES (NULL, 'range', 'Named areas', false, 8, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 15);
INSERT INTO choice VALUES (NULL, '2', 3, 15);
INSERT INTO choice VALUES (NULL, '3', 4, 15);
INSERT INTO choice VALUES (NULL, '4', 5, 15);
INSERT INTO block VALUES (NULL, 'range', 'PDF forms', false, 9, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 16);
INSERT INTO choice VALUES (NULL, '2', 3, 16);
INSERT INTO choice VALUES (NULL, '3', 4, 16);
INSERT INTO choice VALUES (NULL, '4', 5, 16);
INSERT INTO block VALUES (NULL, 'range', ':first-line', false, 10, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 17);
INSERT INTO choice VALUES (NULL, '2', 3, 17);
INSERT INTO choice VALUES (NULL, '3', 4, 17);
INSERT INTO choice VALUES (NULL, '4', 5, 17);
INSERT INTO block VALUES (NULL, 'range', 'Grid', false, 11, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 18);
INSERT INTO choice VALUES (NULL, '2', 3, 18);
INSERT INTO choice VALUES (NULL, '3', 4, 18);
INSERT INTO choice VALUES (NULL, '4', 5, 18);
INSERT INTO block VALUES (NULL, 'range', 'PDF/X-3', false, 12, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 19);
INSERT INTO choice VALUES (NULL, '2', 3, 19);
INSERT INTO choice VALUES (NULL, '3', 4, 19);
INSERT INTO choice VALUES (NULL, '4', 5, 19);
INSERT INTO block VALUES (NULL, 'range', 'Right-to-left and bidirectional text', false, 13, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 20);
INSERT INTO choice VALUES (NULL, '2', 3, 20);
INSERT INTO choice VALUES (NULL, '3', 4, 20);
INSERT INTO choice VALUES (NULL, '4', 5, 20);
INSERT INTO block VALUES (NULL, 'range', 'Factur-X', false, 14, 7);
INSERT INTO choice VALUES (NULL, '1', 2, 21);
INSERT INTO choice VALUES (NULL, '2', 3, 21);
INSERT INTO choice VALUES (NULL, '3', 4, 21);
INSERT INTO choice VALUES (NULL, '4', 5, 21);

INSERT INTO page VALUES (NULL, 8, 1);
INSERT INTO block VALUES (NULL, 'radio', '<h2>Do you know that you can be a CourtBouillon sponsor?</h2>', false, 1, 8);
INSERT INTO choice VALUES (NULL, 'Yes, I already am', 1, 22);
INSERT INTO choice VALUES (NULL, 'Yes, but I’m not interested', 2, 22);
INSERT INTO choice VALUES (NULL, 'Not yet, but I’m going to', 3, 22);
INSERT INTO choice VALUES (NULL, 'No, and I’m not interested', 4, 22);

INSERT INTO page VALUES (NULL, 9, 1);
INSERT INTO block VALUES (NULL, 'checkbox', '<h2>Where do you follow CourtBouillon and WeasyPrint news?</h2>', false, 1, 9);
INSERT INTO choice VALUES (NULL, 'Twitter', 1, 23);
INSERT INTO choice VALUES (NULL, 'GitHub', 2, 23);
INSERT INTO choice VALUES (NULL, 'CourtBouillon website', 3, 23);
INSERT INTO choice VALUES (NULL, 'CourtBouillon RSS', 4, 23);
INSERT INTO choice VALUES (NULL, 'OpenCollective newsletter', 5, 23);
INSERT INTO block VALUES (NULL, 'textarea', '<p>Other</p>', false, 2, 9);
INSERT INTO choice VALUES (NULL, '', 1, 24);

INSERT INTO page VALUES (NULL, 10, 1);
INSERT INTO block VALUES (NULL, 'checkbox', '<h2>Which content are you interested in?</h2>', false, 1, 10);
INSERT INTO choice VALUES (NULL, 'New beta versions', 1, 25);
INSERT INTO choice VALUES (NULL, 'New stable versions', 2, 25);
INSERT INTO choice VALUES (NULL, 'Specific new features', 3, 25);
INSERT INTO choice VALUES (NULL, 'CSS tricks', 4, 25);
INSERT INTO choice VALUES (NULL, 'Technical articles (like the serie about Python packaging)', 5, 25);
INSERT INTO choice VALUES (NULL, 'Historical and political articles (like the serie about web diversity)', 6, 25);

INSERT INTO page VALUES (NULL, 11, 1);
INSERT INTO block VALUES (NULL, 'textarea', '<h2>If you want to add something else or add anything, that’s the moment', false, 1, 11);
INSERT INTO choice VALUES (NULL, '', 1, 26);
