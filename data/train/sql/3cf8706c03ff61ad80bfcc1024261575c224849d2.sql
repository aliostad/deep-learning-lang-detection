-- Write one or more triggers to manage the grade attribute
-- of new Highschoolers. If the inserted tuple has a
-- value less than 9 or greater than 12, change the value to NULL.
-- On the other hand, if the inserted tuple has a
-- null value for grade, change it to 9.


CREATE TRIGGER handle_incorrect_grade AFTER INSERT ON Highschooler
  WHEN new.grade < 9 or new.grade > 12
BEGIN
UPDATE Highschooler SET grade = NULL WHERE id = new.ID;
END;
|
CREATE TRIGGER handle_null_grade AFTER INSERT ON Highschooler
  WHEN new.grade is NULL
BEGIN
UPDATE Highschooler SET grade = 9 WHERE  id = new.ID;
END;
