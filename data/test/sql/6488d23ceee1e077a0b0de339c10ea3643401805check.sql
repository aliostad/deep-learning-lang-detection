-- SQL Checks

/*
-- Start fresh
DROP TABLE
  deed_20151030, deed_20151030_clean, deed_20151030_clean_append, deed_20151030_clean_buyercount;
SHOW TABLES;
*/

-- Deed
SELECT COUNT(*) FROM deed_20151030_clean;
SELECT fips_code FROM deed_20151030 LIMIT 10;

-- Deed Clean
SELECT COUNT(*) FROM deed_20151030_clean;
SELECT Property_Address FROM deed_20151030_clean LIMIT 10;

-- Deed Append
SELECT COUNT(*) FROM deed_20151030_clean_append;
SELECT length_of_residence FROM deed_20151030_clean_append LIMIT 10;

-- Buyer Count
SELECT COUNT(*) FROM deed_20151030_clean_buyercount;
SELECT mail_address, owner_1_label_name FROM deed_20151030_clean_buyercount LIMIT 10;
SELECT * FROM deed_20151030_clean_buyercount LIMIT 10;