/*
Przemysław Pastuszka
Perspektywy i reguły

Perspektywy i reguły służą do okrojenia możliwości update'u - w sposób, jaki został opisany w modelu konceptualnym

Ponadto perspektywa 'uzytkownik_bez_hasla' pozwala na ukrycie haseł użytkowników
*/
drop view if exists uzytkownik_bez_hasla cascade;
drop view if exists komentarz_modyfikacja cascade;
drop view if exists wycieczka_modyfikacja cascade;
drop view if exists trasa_modyfikacja cascade;
drop view if exists kategoria_modyfikacja cascade;

--tworzenie widoków
create view uzytkownik_bez_hasla as select nick, nazwisko, imie, opis, rodzaj_roweru from uzytkownik;
create view komentarz_modyfikacja as select * from komentarz;
create view wycieczka_modyfikacja as select * from wycieczka;
create view trasa_modyfikacja as select * from trasa;
create view kategoria_modyfikacja as select * from kategoria;


--tworzenie reguł edycji
create rule edytuj_uzytkownik as
	on update to uzytkownik_bez_hasla
	do instead
		update uzytkownik set imie = new.imie, nazwisko = new.nazwisko, opis = new.opis, rodzaj_roweru = new.rodzaj_roweru
			where nick = new.nick;
	
create rule edytuj_komentarz as
	on update to komentarz_modyfikacja
	do instead
		update komentarz set tresc = new.tresc where id_komentarz = new.id_komentarz;
		
create rule edytuj_wycieczka as
	on update to wycieczka_modyfikacja
	do instead
		update wycieczka set data = new.data, opis = new. opis where id_wycieczka = new.id_wycieczka;
		
create rule edytuj_trasa as
	on update to trasa_modyfikacja
	do instead
		update trasa set nazwa_kat = new.nazwa_kat, nazwa = new.nazwa, opis = new.opis, zdjecie = new.zdjecie
			where id_trasa = new.id_trasa;
			
create rule edytuj_kategoria as
	on update to kategoria_modyfikacja
	do instead
		update kategoria set opis = new.opis, zdjecie = new.zdjecie where nazwa_kat = new.nazwa_kat;
