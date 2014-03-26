DROP TABLE IF EXISTS rooms;
CREATE TABLE rooms (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

INSERT INTO rooms VALUES 
(1, "Imogen"),
(2, "Master"),
(3, "Amber"),
(4, "Bathroom"),
(5, "Landing"),
(6, "Hall"),
(7, "Lounge"),
(8, "Kitchen"),
(9, "Dining");
