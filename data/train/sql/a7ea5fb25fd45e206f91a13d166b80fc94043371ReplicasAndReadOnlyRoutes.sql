-- This shows a replica server, all of its read only replicas and their routing priority.

select g.name as availability_group_name, r1.replica_server_name, l.routing_priority, r2.replica_server_name as read_only_replica_server_name, r2.read_only_routing_url 
from sys.availability_read_only_routing_lists as l
join sys.availability_replicas as r1 on l.replica_id = r1.replica_id
join sys.availability_replicas as r2 on l.read_only_replica_id = r2.replica_id
join sys.availability_groups as g on r1.group_id = g.group_id

