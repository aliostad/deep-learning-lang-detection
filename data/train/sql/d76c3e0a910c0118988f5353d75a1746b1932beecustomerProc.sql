create or replace 
Procedure Insert_Customer(ssn IN Customers.ssn%TYPE, gender IN customers.gender%TYPE, DOB IN customers.DOB%TYPE, cust_name IN customers.name%TYPE, phone_number IN customers.phone_number%TYPE, email IN customers.email%TYPE, address IN customers.address%TYPE, credit_card IN customers.credit_card%TYPE)
AS
BEGIN
   INSERT INTO customers (SSN, gender,DOB,name,phone_number,email,address,credit_card) VALUES(ssn, gender, DOB, cust_name, phone_number, email, address, credit_card);
   
END Insert_Customer;
/
create or replace 
Procedure Update_Customer(cust_id IN customers.customerid%type, ssn_new IN Customers.ssn%TYPE, gender_new IN customers.gender%TYPE, DOB_new IN customers.DOB%TYPE, cust_name IN customers.name%TYPE, phone_number_new IN customers.phone_number%TYPE, email_new IN customers.email%TYPE, address_new IN customers.address%TYPE, credit_card_new IN customers.credit_card%TYPE)
AS
BEGIN
   Update customers set SSN=ssn_new, gender=gender_new, DOB=DOB_new, name=cust_name, phone_number=phone_number_new, email=email_new, address=address_new,credit_card=credit_card_new where customerid=cust_id;
   
END Update_Customer;
/
create or replace Procedure Delete_Customer(cust_id IN customers.customerid%TYPE)
AS
BEGIN
    Delete from Customers where Customers.customerid=cust_id;
END Delete_Customer;
/
create or replace Procedure Delete_Customer_with_name(name_in IN customers.name%TYPE, address_in IN customers.address%TYPE)
as
BEGIN
    Delete from Customers where name=name_in and address=address_in;
END Delete_Customer_with_name;
/
