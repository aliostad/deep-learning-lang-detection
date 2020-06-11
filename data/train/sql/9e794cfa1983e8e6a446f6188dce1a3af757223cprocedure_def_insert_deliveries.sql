drop procedure start_new_customer;

create procedure start_new_customer  (IN new_streetno integer, 
                                                                  IN new_apt varchar (8), 
                                                                  IN new_streetname varchar (30))
                                                                  

BEGIN
INSERT INTO tduser.ROUTES_DELIVERIES2(StreetNo,Apt, Streetname)  
VALUES(:new_streetno,:new_apt,:new_streetname) ;
END;

select database;

call start_new_customer(99999,'AAAAA','BBBBB')



select databasename, permspace from dbc.databasesx


database dbc;
database tduser;
select database;

show table tduser.routes_deliveries

grant all  on tduser to dbc with grant option