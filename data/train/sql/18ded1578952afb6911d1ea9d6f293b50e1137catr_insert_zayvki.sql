CREATE TRIGGER insert_zayvki BEFORE INSERT 
  ON zayvki FOR EACH ROW 
  BEGIN
    /* Добавление данных в рег. заявки */
    INSERT INTO registry_zayvki SET id_zayvki=NEW.numberPay, data=NEW.date,
      summa=NEW.summaPay, payIn=NEW.payIn, payOut=NEW.payOut, fioClient=NEW.fio,
      mailClient=NEW.mail;
    
    /* Добавляем данные о пользователе, 
       если о нем нет информации у нас БД   */
    INSERT INTO client(mail, telephone, fio) 
    SELECT NEW.mail, NEW.telephone, NEW.fio 
    FROM zayvki z
    WHERE NOT EXISTS(SELECT 1 FROM client c WHERE c.mail=NEW.mail);
  END;