select model,brand,count(*) as C from laptops
where model like "___" or model like "__" or model like "_" or model like "____" or model like "_____" 
group by model,brand
having C >= 40
order by C
;
select model from laptops
where model like "___" or model like "__" or model like "_" or model like "____" or model like "_____" 
group by model,brand
having count(*)  >= 40;

insert into price(url,price)
select url, price from laptop_items;
select count(*) from laptop_specs;

select A.url,B.price from ( select * from laptops limit 100 ) as A, 
		( select * from price ) as B
where A.url = B.url;

select * from laptops
where url = "http://www.fadfusion.com/selection.php?product_item_number=10040808007"