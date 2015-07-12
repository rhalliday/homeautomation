PRAGMA foreign_keys = ON;
CREATE TABLE scenes (
    scene_id INTEGER PRIMARY KEY
    ,name     VARCHAR(50)
    ,room_id  INTEGER REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE
    ,scene    TEXT
);

ALTER TABLE tasks ADD COLUMN scene_id INTEGER REFERENCES scenes(scene_id) ON DELETE CASCADE ON UPDATE CASCADE; 
INSERT INTO role (role) VALUES ('scenes');
