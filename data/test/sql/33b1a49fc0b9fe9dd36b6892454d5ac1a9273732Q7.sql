/*
Short database description "Computer firm":

The database scheme consists of four tables:
Product(maker, model, type)
PC(code, model, speed, ram, hd, cd, price)
Laptop(code, model, speed, ram, hd, screen, price)
Printer(code, model, color, type, price)
The table "Product" includes information about the maker, model number, and type ('PC', 'Laptop', or 'Printer'). It is assumed that model numbers in the Product table are unique for all the makers and product types. Each PC uniquely specifying by a code in the table "PC" is characterized by model (foreign key referencing to Product table), speed (of the processor in MHz), total amount of RAM - ram (in Mb), hard disk drive capacity - hd (in Gb), CD ROM speed - cd (for example, '4x'), and the price. The table "Laptop" is similar to that one of PCs except for the CD ROM speed, which is replaced by the screen size - screen (in inches). For each printer in the table "Printer" it is told whether the printer is color or not (color attribute is 'y' for color printers; otherwise it is 'n'), printer type (laser, jet, or matrix), and the price.

Question: Find out the models and prices for all the products (of any type) produced by maker B.
*/

SELECT A.Model, B. Price
FROM Product A
INNER JOIN PC B
ON A.Model = B.Model
WHERE A.Maker = 'B'

UNION 

SELECT A.Model, C. Price
FROM Product A
INNER JOIN Laptop C
ON A.Model = C.Model
WHERE A.Maker = 'B'

UNION 

SELECT A.Model, D. Price
FROM Product A
INNER JOIN Printer D
ON A.Model = D.Model
WHERE A.Maker = 'B'
