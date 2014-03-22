PRAGMA foreign_keys = ON;
CREATE TABLE tasks (
        id            INTEGER PRIMARY KEY,
        appliance     VARCHAR(3) REFERENCES appliances(address) ON DELETE CASCADE ON UPDATE CASCADE,
        action        TEXT,
        time          TEXT,
        expires       TIMESTAMP
);
CREATE TABLE days (
        id   INTEGER PRIMARY KEY,
        day  TEXT
);
CREATE TABLE tasks_day (
        task_id INTEGER REFERENCES tasks(id) ON DELETE CASCADE ON UPDATE CASCADE,
        day_id INTEGER REFERENCES days(id) ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (task_id, day_id)
);
--
-- Add our days
--
INSERT INTO days (id, day) VALUES (1, 'Monday');
INSERT INTO days (id, day) VALUES (2, 'Tuesday');
INSERT INTO days (id, day) VALUES (3, 'Wednesday');
INSERT INTO days (id, day) VALUES (4, 'Thursday');
INSERT INTO days (id, day) VALUES (5, 'Friday');
INSERT INTO days (id, day) VALUES (6, 'Saturday');
INSERT INTO days (id, day) VALUES (7, 'Sunday');
