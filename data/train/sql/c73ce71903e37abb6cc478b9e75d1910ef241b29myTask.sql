SELECT *
FROM product;
SELECT *
FROM pc;
SELECT *
FROM laptop;
SELECT *
FROM printer;

-- Найдите номер модели, скорость и размер жесткого диска для всех ПК
-- стоимостью менее 500 долларов. Вывести: model, speed и hd
SELECT
  model,
  speed,
  hd
FROM computer.pc
WHERE price < 500;

-- Найдите производителей принтеров. Вывести: maker.
SELECT DISTINCT maker
FROM computer.product
WHERE type = 'Printer';

-- Найдите номер модели, объем памяти и размеры экранов портативных
-- компьютеров, цена которых превышает 1000 долларов.
SELECT
  model,
  ram,
  screen
FROM laptop
WHERE price > 1000;

-- Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12х или 24х CD и цену менее 600 долларов.
SELECT
  model,
  speed,
  hd
FROM pc
WHERE (cd = '12x' OR cd = '24x') AND pc.price < 600;
SELECT
  model,
  speed,
  hd
FROM pc
WHERE cd IN ('12x', '24x') AND pc.price < 600;

--Укажите производителя и скорость портативных компьютеров с жестким диском объемом не менее 10 Гбайт

SELECT DISTINCT
  p.maker,
  l.speed
FROM product p, laptop l
WHERE p.model = l.model AND l.hd >= 10;

SELECT DISTINCT
  p.maker,
  l.speed
FROM product p
  JOIN laptop l ON p.model = l.model
WHERE l.hd >= 10;

-- Найдите номера моделей и цены всех продуктов (любого типа) выпущенных производителем B (латинская буква).

SELECT
  model,
  price
FROM pc
WHERE model IN (SELECT model
                FROM product
                WHERE maker = 'B' AND type = 'PC')
UNION
SELECT
  model,
  price
FROM laptop
WHERE model IN (SELECT model
                FROM product
                WHERE maker = 'B' AND type = 'Laptop')
UNION
SELECT
  model,
  price
FROM printer
WHERE model IN (SELECT model
                FROM product
                WHERE maker = 'B' AND type = 'Printer');
