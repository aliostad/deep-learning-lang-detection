DROP TRIGGER IF EXISTS user_insert;
delimiter $$
CREATE TRIGGER user_insert
AFTER INSERT ON almab_customers 
FOR EACH ROW
    BEGIN
    SET @new_id = NEW.id;
    SET @new_email = NEW.email;
    SET @new_descr = NEW.descr;
   INSERT INTO `users` (`username`, `password`, `email`, `superuser`, `status`) VALUES (@new_id, md5(@new_id), @new_email, 0, 1);
   INSERT INTO `profiles` (`lastname`, `firstname`) VALUES (SUBSTRING_INDEX(@new_descr, ' ', 1), SUBSTRING(@new_descr, LOCATE(' ' , @new_descr)+1));
   
END $$
delimiter ;;