CREATE TABLE TSP (
    id SERIAL PRIMARY KEY, point1 VARCHAR(255), point2 VARCHAR(255), cost INT NOT NULL DEFAULT 0
);

INSERT INTO
    TSP (point1, point2, cost)
VALUES ('A', 'B', 10),
    ('B', 'A', 10),
    ('A', 'C', 15),
    ('C', 'A', 15),
    ('A', 'D', 20),
    ('D', 'A', 20),
    ('B', 'C', 35),
    ('C', 'B', 35),
    ('C', 'D', 30),
    ('D', 'C', 30),
    ('D', 'B', 25),
    ('B', 'D', 25);

WITH RECURSIVE
    graph AS (
        SELECT
            point1, point2, CAST(
                point1 || ',' || point2 AS VARCHAR(255)
            ) AS tour, cost as total, 1 AS lvl
        FROM TSP
        WHERE
            point1 = 'A'
        UNION
        SELECT g.point1, p.point2, CAST(
                g.tour || ',' || p.point2 AS VARCHAR(255)
            ), g.total + p.cost AS total, g.lvl + 1
        FROM graph g
            JOIN TSP p ON g.point2 = p.point1
            AND RIGHT(g.tour, 1) <> 'A'
        WHERE
            g.lvl < 5
            AND g.tour NOT LIKE '%' || p.point2 || '%'
            OR p.point2 = 'A'
    ),
    TEMP AS (
        SELECT *
        FROM graph
        WHERE
            tour LIKE 'A%A'
            AND lvl = 4
    )
SELECT total, LOWER(CONCAT('{', tour, '}')) AS tour, lvl
FROM TEMP
WHERE
    total IN (
        SELECT MIN(total)
        FROM TEMP
    )
ORDER BY total, tour;

-- DROP TABLE TSP;