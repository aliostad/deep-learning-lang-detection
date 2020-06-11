use computer;
With Tbl (avgP) AS
(
select price from dbo.PC
where model in (
select distinct model from dbo.Product
where maker = 'A' 
and type = 'PC'
)

union all

select A.price from dbo.Laptop AS A
where A.model in (
select distinct model from dbo.Product
where maker = 'A' 
and type = 'Laptop'
)
)

select avg(avgP) from Tbl

select model, price from dbo.PC
where model in (
select distinct model from dbo.Product
where maker = 'A' 
and type = 'PC')

select A.model, A.price from dbo.Laptop AS A
where A.model in (
select distinct model from dbo.Product
where maker = 'A' 
and type = 'Laptop'
)
