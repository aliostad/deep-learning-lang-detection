create table customer
(
	customer_id int primary key,
	customer_name text,
	count  int

);

INSERT INTO customer(customer_id,customer_name) values (1,'Lorie', 3);
INSERT INTO customer(customer_id,customer_name) values (2,'Jennie', 3);
INSERT INTO customer(customer_id,customer_name) values (3, 'Onna', 3);
INSERT INTO customer(customer_id,customer_name) values (4, 'Cristy', 3);
INSERT INTO customer(customer_id,customer_name) values (5, 'Dareen', 3);
-------------------------------------------------------------------------------
create or replace
 function getcustomer_name (in int, out text)
 returns text as

 $$
  select customer_name from customer
  where customer_id = $1;
 $$
  language 'sql';
-----------------------------------------------------------------------------
create or replace
 function getcount (in int, out int)
 returns int as

 $$
  select count from customer
  where customer_id = $1;
 $$
  language 'sql';
  ----------------------------------------------------------------------------