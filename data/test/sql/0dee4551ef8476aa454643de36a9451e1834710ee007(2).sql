use computer;

-- v 1

select m.model, p.price from PC as p 
JOIN Product AS m ON m.model = p.model WHERE m.maker = 'B'

union

select m.model, l.price from Laptop as l
JOIN Product AS m ON m.model = l.model WHERE m.maker = 'B'

union

select m.model, t.price from Printer as t
JOIN Product AS m ON m.model = t.model WHERE m.maker = 'B'

-- v 2

select model, price 
from PC where model in 
(
select model from Product where maker = 'B' AND type = 'PC'
)

union

select model, price 
from Laptop where model in 
(
select model from Product where maker = 'B' AND type = 'Laptop'
)

union

select model, price 
from Printer where model in 
(
select model from Product where maker = 'B' AND type = 'Printer'
)