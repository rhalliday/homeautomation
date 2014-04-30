PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS appliances;
CREATE TABLE appliances (
    address  VARCHAR(3) PRIMARY KEY,
    device   VARCHAR(50),
    room_id  INTEGER REFERENCES rooms(id) ON DELETE CASCADE ON UPDATE CASCADE,
    protocol CHAR(2),
    status   BOOLEAN,
    setting  SMALLINT,
    dimable  BOOLEAN,
    timings  SMALLINT,
    colour   CHAR(7)
);

-- insert the 16 records we can have for an address
INSERT INTO appliances (address) VALUES ('F1'),('F2'),('F3'),('F4'),('F5'),('F6'),('F7'),('F8'),('F9'),('F10'),('F11'),('F12'),('F13'),('F14'),('F15'),('F16');
