USE RentACar

SELECT Registracija, Model.Naziv
FROM Vozilo
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
ORDER BY 2 ASC

SELECT Registracija, Model.Naziv, Proizvodjac.Naziv
FROM Vozilo
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
INNER JOIN Proizvodjac ON Proizvodjac.IDProizvodjac = Model.IDProizvodjac
ORDER BY 3 ASC

SELECT Registracija, Model.Naziv, Kategorija.Naziv
FROM Vozilo
INNER JOIN Kategorija ON Kategorija.IDKategorija = Vozilo.KategorijaID
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
ORDER BY 3 ASC

SELECT Registracija, Model.Naziv, Proizvodjac.Naziv, Kategorija.Naziv
FROM Vozilo
INNER JOIN Model ON Model.IDModel = Vozilo.ModelID
INNER JOIN Proizvodjac ON Model.IDProizvodjac = Proizvodjac.IDProizvodjac
INNER JOIN Kategorija ON Kategorija.IDKategorija = Vozilo.KategorijaID
ORDER BY 1 ASC