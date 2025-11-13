create database suplier;
use suplier;

CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(30)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);

INSERT INTO Supplier VALUES
(1, 'Acme Widget Suppliers', 'New York'),
(2, 'Superior Parts Co.', 'Chicago'),
(3, 'Global Supplies', 'Dallas');

INSERT INTO Parts VALUES
(101, 'Bolt', 'Red'),
(102, 'Nut', 'Blue'),
(103, 'Screw', 'Red'),
(104, 'Washer', 'Green');

INSERT INTO Catalog VALUES
(1, 101, 10.00),
(1, 102, 15.00),
(2, 101, 12.00),
(2, 103, 9.00),
(3, 101, 11.00),
(3, 102, 16.00),
(3, 104, 20.00);

SELECT DISTINCT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid;

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
    AND p.pid NOT IN (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid
    )
);

SELECT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
JOIN Supplier s ON c.sid = s.sid
WHERE s.sname = 'Acme Widget Suppliers'
GROUP BY p.pid, p.pname
HAVING COUNT(DISTINCT s.sid) = 1;

SELECT DISTINCT c1.sid
FROM Catalog c1
JOIN (
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) AS avg_table ON c1.pid = avg_table.pid
WHERE c1.cost > avg_table.avg_cost;

SELECT p.pname, s.sname, c.cost
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE (c.pid, c.cost) IN (
    SELECT pid, MAX(cost)
    FROM Catalog
    GROUP BY pid
);