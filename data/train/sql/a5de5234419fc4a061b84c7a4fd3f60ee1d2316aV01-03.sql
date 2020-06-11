USE RentACar

SELECT Proizvodjac.IDProizvodjac,
(SELECT COUNT(*) FROM Model WHERE Proizvodjac.IDProizvodjac = Model.IDProizvodjac) AS Broj
FROM Proizvodjac
ORDER BY 2 DESC

SELECT Proizvodjac.Naziv,
(SELECT COUNT(*) FROM Model WHERE Model.IDProizvodjac = Proizvodjac.IDProizvodjac) AS Broj
FROM Proizvodjac
ORDER BY 2 DESC

SELECT MAX(CijenaPoDanu) * 10 AS Najskuplje,
MIN(CijenaPoDanu) * 10 AS Najjeftinije
FROM Vozilo

SELECT SUM(Kilometraza) AS Opeli
FROM Vozilo
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
INNER JOIN Proizvodjac ON Proizvodjac.IDProizvodjac = Model.IDProizvodjac
WHERE Proizvodjac.Naziv = 'Opel'

SELECT COUNT(*) AS BrojKlijenata
FROM Klijent

SELECT Ime, Prezime
FROM Klijent
WHERE Grad = 'Varaždin' AND
EMail IS NULL