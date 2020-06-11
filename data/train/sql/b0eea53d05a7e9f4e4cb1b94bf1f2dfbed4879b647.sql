select * from Product
select * from PC

SELECT P1.model, P2.model 
FROM Product P1 JOIN 
 Product P2 ON P1.model <= P2.model

SELECT COUNT(*) no, P2.model 
FROM Product P1 JOIN 
 Product P2 ON P1.model <= P2.model 
GROUP BY P2.model

select * from Product
ORDER BY Product.model

select ROW_NUMBER() OVER(ORDER BY Product.model) no, Product.model from Product


SELECT id_psg 
FROM pass_in_trip;

select * from Pass_in_trip

SELECT COUNT(*) num, P2.id_psg
FROM (SELECT *, CAST(date AS CHAR(11)) +
                RIGHT('00' + CAST(id_psg AS VARCHAR(2)), 2)+
                CAST(trip_no AS CHAR(4)) dit
       FROM Pass_in_trip
      ) P1 JOIN
      (SELECT *, CAST(date AS CHAR(11)) +
                 RIGHT('00' + CAST(id_psg AS VARCHAR(2)), 2)+
                 CAST(trip_no AS CHAR(4)) dit
       FROM pass_in_trip
       ) P2 ON P1.dit <= P2.dit
GROUP BY P2.dit, P2.id_psg
ORDER BY 1;

SELECT ROW_NUMBER() OVER(ORDER BY date, id_psg, trip_no) num, id_psg
FROM Pass_in_trip
ORDER BY num;

select ROW_NUMBER() over(ORDER BY p.model,p.type,p.maker) no, p.maker,p.model from Product p

select * from Product WHERE Product.maker = 'A' or Product.maker = 'E' 
ORDER BY Product.type

select row_number() over(ORDER BY p1.cnt desc) no,p1.maker from 
(select p.maker,count(*) cnt from Product p
GROUP by p.maker,p.model) p1
--ORDER BY p1.cnt desc

select * from Product p 

/*
Ïðîíóìåðîâàòü ñòðîêè èç òàáëèöû Product â ñëåäóþùåì ïîðÿäêå: èìÿ ïðîèçâîäèòåëÿ â ïîðÿäêå 
óáûâàíèÿ ÷èñëà ïðîèçâîäèìûõ èì ìîäåëåé (ïðè îäèíàêîâîì ÷èñëå ìîäåëåé èìÿ ïðîèçâîäèòåëÿ 
â àëôàâèòíîì ïîðÿäêå ïî âîçðàñòàíèþ), íîìåð ìîäåëè (ïî âîçðàñòàíèþ).
Âûâîä: íîìåð â ñîîòâåòñòâèè ñ çàäàííûì ïîðÿäêîì, èìÿ ïðîèçâîäèòåëÿ (maker), ìîäåëü (model) 
*/

/*
no	maker	model
1	A	1232
10	E	2112
11	E	2113
12	B	1121
13	B	1750
14	D	1288
15	D	1433
16	C	1321
2	A	1233
3	A	1276
4	A	1298
5	A	1401
6	A	1408
7	A	1752
8	E	1260
9	E	1434
*/
select * from Product p 
select count(*) as A from Product p WHERE p.maker='A'

select count(*) as E  from Product p WHERE p.maker='E'

select count(*) AS B from Product p WHERE p.maker='B'

select count(*) AS D from Product p WHERE p.maker='D'

select count(*) AS C from Product p WHERE p.maker='C'



with cte AS (SELECT ROW_NUMBER() OVER(partition by p.maker ORDER BY  p.model) no,p.maker, p.model from Product p)


--select x.no, x.maker, x.model from cte x
--ORDER BY  (select max(no) FROM cte c )
select  rn,vv.maker,vv.model from (
SELECT row_number() over(ORDER BY pr.model,mn,v.maker)rn, v.mn,v.maker,pr.model from (
select count(p.model) mn,p.maker from cte p
group BY p.maker) v
left JOIN
(select row_number()over(ORDER BY p.model) row,p.maker,p.model from Product p) pr
 ON pr.maker=v.maker) vv
ORDER BY  vv.mn desc, vv.model, vv.maker

select row_number()over(order by count(c.no)) row from cte c

--_yizraor [AR]
SELECT N = ROW_NUMBER() OVER (ORDER BY Q DESC, MAKER ASC, MODEL ASC), MAKER, MODEL
 FROM (   SELECT MAKER, MODEL, Q = COUNT(*) OVER (PARTITION BY MAKER)   FROM PRODUCT ) T
 
 --herrRo [AR]
 Select row_number() over(order by cc desc,maker,model),
  maker,
  model From Product p 
  Cross Apply ( Select count(model) cc From Product Where maker=p.maker ) C


--A_ntoha   
  select row_number() over (order by count(p1.model) desc,p1.maker,p2.model) num, p1.maker, 
 p2.model
from product p1 join  product p2 on p1.maker=p2.maker
group by p1.maker,p2.model


--tamuna 
with new as
(select ROW_NUMBER() over(order by count(*) desc, maker asc) rn ,  maker from Product group by maker)

select ROW_NUMBER() over(order by new.rn asc, model asc) ss, product.maker,  product.model
from Product inner join new on Product.maker = new.maker 