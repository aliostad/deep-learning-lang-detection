-- 6.1.3 (A) --
SELECT model, speed, hd_size 
FROM PC
WHERE (price < 1000)

-- 6.1.3 (B) --
SELECT model, speed AS gigahertz, hd_size AS gigabytes
FROM PC
WHERE (price < 1000)

-- 6.1.3 (C) --
SELECT model
FROM Printer

-- 6.1.3 (D) --
SELECT model, ram, screen_size
FROM Laptop
WHERE (price > 1500)

-- 6.1.3 (E) --
SELECT * 
FROM Printer
WHERE (color = 1)

-- 6.1.3 (F) --
SELECT model, hd_size
FROM PC
WHERE (speed = 3.2) AND (price < 2000)

-- 6.2.2 (A) --
SELECT model, speed
FROM Laptop
WHERE (hd_size >= 30)

-- 6.2.2 (B) --
SELECT DISTINCT PC.model, PC.price, Laptop.model, Laptop.price, Printer.model, Printer.price
FROM Product, PC, Laptop, Printer
WHERE (Product.maker = 'B')

-- 6.2.2 (C) --
SELECT DISTINCT maker
FROM Product P
WHERE (P.ptype = 'pc')
EXCEPT
SELECT DISTINCT maker
FROM Product P
WHERE (P.ptype = 'laptop')

-- 6.2.2 (D) --
SELECT hd_size
FROM PC
GROUP BY hd_size
HAVING COUNT(model) >= 2

-- 6.2.2 (E) --
SELECT PC1.model, PC2.model
FROM PC PC1, PC PC2
WHERE PC1.model < PC2.model AND PC1.speed = PC2.speed AND PC1.ram = PC2.ram

-- 6.2.2 (F) --
SELECT DISTINCT P1.maker
FROM Product P1, Product P2
WHERE (P1.maker = P2.maker)
AND P1.model IN 
	(SELECT PC.model
	 FROM PC
	 WHERE PC.speed > 3.00
	 UNION
	 SELECT Laptop.model
	 FROM Laptop
     WHERE Laptop.speed > 3.00)
AND P2.model IN 
	(SELECT PC.model
	 FROM PC
	 WHERE PC.speed > 3.00
	 UNION
	 SELECT Laptop.model
	 FROM Laptop
	 WHERE Laptop.speed > 3.00)
AND P1.model <> P2.model

-- 6.3.1 (A) --
SELECT DISTINCT Product.maker
FROM Product, PC
WHERE (Product.ptype = 'pc') AND (Product.model = PC.model AND PC.speed >= 3.0);

-- 6.3.1 (B) --
SELECT model, price 
FROM Printer, 
(SELECT MAX(price) AS maxPrice  
FROM Printer) AS mp 
WHERE price = mp.maxPrice

-- 6.3.1 (C) --
SELECT *
FROM Laptop 
WHERE Laptop.speed < (SELECT MIN(speed) FROM PC)

-- 6.3.1 (D) --
SELECT  model 
FROM (SELECT  model, price 
      FROM PC
      WHERE price = (SELECT MAX(price) 
                     FROM PC)
      UNION
      SELECT model, price 
      FROM Laptop
      WHERE price = (SELECT MAX(price) 
                     FROM Laptop)
      UNION
      SELECT model, price 
      FROM Printer
      WHERE price = (SELECT MAX(price) 
                     FROM Printer)
      ) T WHERE price = (SELECT MAX(price) 
						 FROM Laptop);

-- 6.3.1 (E) --
SELECT DISTINCT maker
FROM Product
WHERE model = 
(
	SELECT MIN(P.model)
	FROM
	(
		SELECT model 
		FROM Printer
		WHERE color = 1
	) P
) AND ptype = 'printer'

-- 6.3.1 (F) -- 
SELECT DISTINCT maker
	FROM Product
	WHERE model = 
	(
		SELECT T.model
		FROM
		(
		SELECT TOP 1 P.model, MAX(P.speed) AS speed
		FROM
		(
			SELECT model, speed 
			FROM PC
			WHERE ram = 
			(
				SELECT MIN(ram) 
				FROM PC
			)
		) P 
		GROUP BY model
		ORDER BY speed DESC
	) T
)


SELECT P.model, MAX(P.speed) AS speed
FROM
(
	SELECT model, speed 
	FROM PC
	WHERE ram = 
	(
		SELECT MIN(ram) 
		FROM PC
	)
) P 
GROUP BY model
ORDER BY speed DESC



-- 6.4.6 (A) --
SELECT AVG(speed) as avg_speed
FROM PC

-- 6.4.6 (B) --
SELECT AVG(L.speed) as avg_speed
FROM
(
	SELECT *
	FROM laptop
	WHERE price > 1000
) L

-- 6.4.6 (C) --
SELECT AVG(P.price)
FROM
(
	SELECT price 
	FROM PC
	WHERE model IN 
	(
		SELECT model 
		FROM Product
		WHERE ptype = 'pc' AND maker = 'A'
	)
) P

-- 6.4.6 (D) --
SELECT AVG(P.price)
FROM
(
	SELECT price 
	FROM PC
	WHERE model IN 
	(
		SELECT Pp.model
		FROM
		(
			SELECT * 
			FROM Product 
			WHERE maker = 'A'
		) Pp
		WHERE ptype = 'pc' OR ptype = 'laptop'
	)
) P