#3.1.a
select 'pc.model', 'pc.speed', 'pc.hd' 
union
select model , speed , hd from pc where price < 1000
into outfile 'd:/assign.3.5.a.csv'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
;
# Please note that if i use outfile then cloumn names do not appear.
# I can hardcode the column names using the select and union then outfile
#3.1.b
select model, speed as 'gigahertz', hd as 'gigabytes' from pc where price < 1000;
# if i export the result from the workbench ide then the column names appear in the cvs file. 
#3.1.c
select distinct maker from product, laptop where product.model = laptop.model;
#3.1.d
select model, ram, screen from laptop where price > 1000;
#3.1.e 
select * from printer where color = true;
#3.1.f
select model, hd from pc where speed like 3.2 and price < 2000 ;

#3.2.a
select maker, speed from product natural join laptop where hd >= 30;
#3.2.b
(select product.model, price from product, pc where product.model = pc.model 
and maker = 'B')
union
(select Product.model, price from Product, Laptop where Product.model = Laptop.model
and maker = 'B')
union
(select Product.model, price from Product, Printer where Product.model = Printer.model 
and maker = 'B');
#3.2.c
select distinct maker from product where ctype = 'laptop' and maker not in (select maker from product where ctype ='pc'); 
#3.2.d
select hd from pc group by hd having (count(hd)>1) ;
#3.2.e
select p1.model, p2.model from pc p1, pc p2
where p1.speed=p2.speed and p1.ram=p2.ram and p1.model>p2.model;
#3.2.f
select maker from ((select model, speed from pc)
union
(select model, speed from laptop))m
natural join product where speed>=3.0 group by maker having count(m.model) >= 2;

#3.3.a
select distinct product.maker from product natural join pc where speed>=3.0;
#3.3.b
select * from printer where price>= all(select price from printer);
#3.3.c
select model from laptop where speed < all(select speed from pc);
#3.3.d

#3.3.e
Select distinct maker from Product, Printer
where color=true and Printer.model=Product.model
and price <= ALL (Select price from Printer where color=true);

#3.3.f
select distinct maker from product, pc
where product.model=pc.model
and ram <= all (select ram from pc)
and Speed >= all (select speed from pc where ram=(select min(ram) from pc));

#3.4.a
select avg(speed) from pc;

#3.4.b
select avg(speed) from laptop where price>1000;

#3.4.c
select avg(price) from pc,product where product.model = pc.model and maker ='A';

#3.4.d
select avg(pc.price + laptop.price) from pc,laptop;

#3.4.e
select avg(price),speed from pc group by speed;

#3.4.f
select maker,avg(screen) from product,laptop where product.model=laptop.model group by maker;

#3.4.g
select maker from product where ctype='pc' group by maker having count(model)>2;

#3.4.h
select maker,price from product,pc where product.model = pc.model group by maker having max(pc.price); 

#3.4.i
select avg(price),speed from pc group by speed having(speed>2);

#3.4.j
select maker,avg(hd) from pc, product where pc.model=product.model and product.maker
in(select distinct maker from Product where ctype='printer')
group by product.maker;

#3.5.a
insert into pc value(1100,3.2,1024,180,2400);
insert into product value('C',1100,'pc');
select * from pc;
select * from product;

#3.5.b
select * from product;
insert into product(maker,model,ctype)
select maker,model+100,'laptop' from product where ctype = 'pc';

insert into laptop(model,speed,ram,hd,screen,price)
select model+100,speed,ram,hd,17,price+500 from pc;

#3.5.c
delete from pc where hd<100;

#3.5.d

#3.5.e
update product set maker = 'A' where maker = 'B';

#3.5.f
update pc set ram = 2*ram, hd=hd+60;

#3.5.g
update laptop set screen = screen+1, price = price-100 where model in(select model from product where maker ='B');
