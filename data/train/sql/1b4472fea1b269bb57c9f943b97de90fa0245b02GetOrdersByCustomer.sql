select
  'net.squarelabs.sqorm.demo.Customer' as classpath,
  c.*
from [Customer] c
where c.[CustomerId]=@CustomerId
;

select
  'net.squarelabs.sqorm.demo.Orders' as classpath,
  o.*
from [Customer] c
inner join [Orders] o
on o.customer_id=c.[CustomerId]
where c.[CustomerId]=@CustomerId
;

select
  'net.squarelabs.sqorm.demo.OrderDetails' as classpath,
  od.*
from [Customer] c
inner join [Orders] o
on o.customer_id=c.[CustomerId]
inner join [OrderDetails] od
on od.order_id=o.order_id
where c.[CustomerId]=@CustomerId
;
