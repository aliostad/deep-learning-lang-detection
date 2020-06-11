USE AdventureWorks2008R2
GO

--Âûâåñòè íàèìåíîâàíèå òîâàðà (òàáëèöà Production.Product, ïîëÿ Pro-ductModelID è 
--Name), êîòîðîìó â òàáëèöå Production.ProductModel (ïîëÿ Pro-ductModelID è Name) 
--ñîîòâåòñòâóåò íàèìåíîâàíèå 'Long-sleeve logo jersey' (êîôòà ñ äëèííûìè ðóêàâàìè, 
--ñ ýìáëåìîé). 
--Ñîñòàâèòü çàïðîñû ñ èñïîëüçîâàíè-åì êëþ÷åâîãî ñëîâà EXISTS è êëþ÷åâîãî ñëîâà IN.

SELECT p.ProductModelID, p.Name
FROM Production.Product p
WHERE  p.ProductModelID  IN 
	(
		SELECT s.ProductModelID
		FROM Production.ProductModel s
		WHERE s.Name = 'Half-Finger Gloves'
	)
	
SELECT p.ProductModelID, p.Name
FROM Production.Product p
WHERE EXISTS 
	(
		SELECT s.ProductModelID
		FROM Production.ProductModel s
		WHERE s.Name = 'Half-Finger Gloves' and p.ProductModelID = s.ProductModelID
	)