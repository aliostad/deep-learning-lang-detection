/*Caleb Meador meadorjc at gmail.com*/
use MyGuitarShop;

declare @newcustomer xml;

set @newcustomer = 
'<NewCustomers>
	<Customer EmailAddress="izzychan@yahoo.com" Password="" FirstName="Isabella" LastName="Chan" />
	<Customer EmailAddress="johnprine@gmail.com" Password="" FirstName="John" LastName="Prine" />
	<Customer EmailAddress="kathykitchen@sbcglobal.net" Password="" FirstName="Kathy" LastName="Kitchen" />
</NewCustomers>';

insert customers(EmailAddress, Password, FirstName, LastName)
values ( @newcustomer.value('(/NewCustomers/Customer/@emailaddress)[1]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@password)[1]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@firstname)[1]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@lastname)[1]', 'varchar(50)')
 ),
 ( @newcustomer.value('(/NewCustomers/Customer/@emailaddress)[2]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@password)[2]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@firstname)[2]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@lastname)[2]', 'varchar(50)')
 ),
 ( @newcustomer.value('(/NewCustomers/Customer/@emailaddress)[3]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@password)[3]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@firstname)[3]', 'varchar(50)'),
 @newcustomer.value('(/NewCustomers/Customer/@lastname)[3]', 'varchar(50)')
 )

