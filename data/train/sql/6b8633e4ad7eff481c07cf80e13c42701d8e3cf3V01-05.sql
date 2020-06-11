USE RentACar

SELECT DatumOd, DatumDo, StatusVozila.Naziv, Proizvodjac.Naziv,
Kategorija.Naziv, Klijent.Ime, Klijent.Prezime
FROM Najam
INNER JOIN StatusVozila ON StatusVozila.IDStatusVozila = Najam.StatusVozilaID
INNER JOIN Klijent ON Klijent.IDKlijent = Najam.KlijentID
INNER JOIN Vozilo ON Vozilo.IDVozilo = Najam.VoziloID
INNER JOIN Kategorija ON Kategorija.IDKategorija = Vozilo.KategorijaID
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
INNER JOIN Proizvodjac ON Proizvodjac.IDProizvodjac = Model.IDProizvodjac

SELECT IDNajam
FROM Najam
WHERE DatumDo BETWEEN '2014-09-20' AND '2014-09-27'

SELECT Proizvodjac.Naziv
FROM Proizvodjac
LEFT OUTER JOIN Model ON Model.IDProizvodjac = Proizvodjac.IDProizvodjac
WHERE Proizvodjac.IDProizvodjac IS NULL

SELECT Proizvodjac.Naziv
FROM Proizvodjac
WHERE Proizvodjac.IDProizvodjac NOT IN
(SELECT Model.IDProizvodjac FROM Model WHERE Model.IDProizvodjac = Proizvodjac.IDProizvodjac)

SELECT Model.Naziv AS Model, ISNULL(Proizvodjac.Naziv, 'UNKNOWN') AS Proizvodjac
FROM Model
INNER JOIN Proizvodjac ON Proizvodjac.IDProizvodjac = Model.IDProizvodjac

SELECT TOP 2 Proizvodjac.Naziv,
(SELECT COUNT(*) FROM Model WHERE Model.IDProizvodjac = Proizvodjac.IDProizvodjac)
FROM Proizvodjac
ORDER BY 2 DESC