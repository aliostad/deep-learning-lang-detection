select 
	id_sale,
	concat(merchant.surname,' ', merchant.name) as merchant_name,
	concat(customer.surname,' ', customer.name) as customer_name,
	car_mark.name as car_mark,
	car_model.name as car_model,
	price,
	sale_date
from 
	sales
inner join merchant 
	on merchant.id_merchant = sales.id_merchant
inner join customer 
	on customer.id_customer = sales.id_customer
inner join car_modification
	on car_modification.id_car_modification = sales.id_car_modification
inner join car_model 
	on car_model.id_car_model = car_modification.id_car_model
inner join car_mark 
	on car_mark.id_car_mark = car_model.id_car_mark