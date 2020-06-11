select customer.custkey, sum(lineitem.extendedprice * (1 - lineitem.discount)) as revenue, customer.acctbal, nation.name, customer.address, customer.phone, customer.comment
from customer, orders, lineitem, nation
where customer.custkey = orders.custkey
and lineitem.orderkey = orders.orderkey
and orders.orderdate >= date('1995-06-05')
and orders.orderdate < date('1995-09-05')
and lineitem.returnflag = 'R'
and customer.nationkey = nation.nationkey
group by customer.custkey, customer.acctbal, customer.phone, nation.name, customer.address, customer.comment
order by revenue asc
limit 20;
