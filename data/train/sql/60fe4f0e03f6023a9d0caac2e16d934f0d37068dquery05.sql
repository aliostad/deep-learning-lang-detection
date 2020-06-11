UPDATE LINEITEM SET RETURNFLAG='R' WHERE LINENUMBER<2;
select customer.custkey, sum(lineitem.extendedprice * (1 - lineitem.discount)) as revenue, customer.acctbal, nation.name, customer.address, customer.phone, customer.comment
from customer, orders, lineitem, nation
where customer.custkey = orders.custkey
and lineitem.orderkey = orders.orderkey
and orders.orderdate >= date('1995-03-05')
and orders.orderdate < date('1995-03-15')
and lineitem.returnflag = 'R'
and customer.nationkey = nation.nationkey
group by customer.custkey, customer.acctbal, customer.phone, nation.name, customer.address, customer.comment
order by revenue asc
limit 100;
