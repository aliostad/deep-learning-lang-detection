-- SQL Views
-- A view is a virtual table.
-- create, update, and delete a view.
-- In SQL, a view is a virtual table based on the result-set of an SQL statement.
-- You can add SQL functions, WHERE, and JOIN statements to a view and present the data as if the data were coming from one single table.


-- SQL CREATE VIEW Statement
CREATE VIEW view_name AS
SELECT column_name(s)
FROM table_name
WHERE condition

-- We can query the view above as follows:
SELECT * FROM [view_name]

-- SQL Updating a View
CREATE OR REPLACE VIEW view_name AS
SELECT column_name(s)
FROM table_name
WHERE condition

-- Now we want to add the "Category" column to the "Current Product List" view. We will update the view with the following SQL:

CREATE OR REPLACE VIEW [Current Product List] AS
SELECT ProductID,ProductName,Category
FROM Products
WHERE Discontinued=No

-- SQL Dropping a View
DROP VIEW view_name
