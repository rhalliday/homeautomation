DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO rooms VALUES 
(1, "Imogen's Room"),
(2, "Master Bedroom"),
(3, "Amber's Bedroom"),
(4, "Bathroom"),
(5, "Landing"),
(6, "Hall"),
(7, "Lounge"),
(8, "Kitchen"),
(9, "Dining Room");
