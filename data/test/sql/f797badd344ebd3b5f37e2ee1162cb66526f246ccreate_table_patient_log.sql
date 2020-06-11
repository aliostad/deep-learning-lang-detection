CREATE TABLE IF NOT EXISTS 'Patient_Log' (
   'plkey' INTEGER PRIMARY KEY AUTOINCREMENT,
   'P_NHS_number_OLD' int(10),
   'P_NHS_number_NEW' int(10),
   'P_first_name_OLD' varchar(20),
   'P_first_name_NEW' varchar(20),
   'P_middle_name_OLD' varchar(20),
   'P_middle_name_NEW' varchar(20),
   'P_surname_OLD' varchar(20),
   'P_surname_NEW' varchar(20),
   'P_date_of_birth_OLD' DATE,
   'P_date_of_birth_NEW' DATE,
   'P_postcode_OLD' varchar(8),
   'P_postcode_NEW' varchar(8),
   'SQL_action' varchar(15),
   'Time_enter' DATE
);
