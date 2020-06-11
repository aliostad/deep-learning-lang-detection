-- WYZWALACZE
/* CREATE TRIGGER nowy_id_powiat
  BEFORE INSERT
  ON powiaty
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE TRIGGER nowy_id_miej
  BEFORE INSERT
  ON miejscowosci
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_wojewodz
  BEFORE INSERT
  ON wojewodztwa
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_gmina
  BEFORE INSERT
  ON gminy
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id(); */
CREATE TRIGGER nowy_id_epoka
  BEFORE INSERT
  ON epoki
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE TRIGGER nowy_id_kultura
  BEFORE INSERT
  ON kultury
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_funkcja
  BEFORE INSERT
  ON funkcje
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_akt
  BEFORE INSERT
  ON aktualnosci
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
create trigger nowy_id_eksp
  BEFORE INSERT
  ON ekspozycje
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE TRIGGER nowy_id_fakt
  BEFORE INSERT
  ON fakty
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_gleba
  BEFORE INSERT
  ON gleby
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_info
  BEFORE INSERT
  ON informacje
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id(); 
CREATE TRIGGER nowy_id_karta
  BEFORE INSERT
  ON karty
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE TRIGGER nowy_id_lokalizacja
  BEFORE INSERT
  ON lokalizacje
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_obszar
  BEFORE INSERT
  ON obszary
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_poloz
  BEFORE INSERT
  ON polozenia
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_wniosek
  BEFORE INSERT
  ON wnioski
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
CREATE  TRIGGER nowy_id_zagroz
  BEFORE INSERT
  ON zagrozenia
  FOR EACH ROW
  EXECUTE PROCEDURE fun_new_id();
