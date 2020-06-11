-- create new properties table with dup_id for each entry

drop table new_properties_dup_id;

create table new_properties_dup_id as 
(
select *
from new_properties
left join unique_addresses
using (new_street_number, new_street_name, new_street_direction, new_unit_number, city_id)
);

-- change -1 values back to null in new properties table
update new_properties_dup_id set new_street_direction = null where new_street_direction = '-1';
update new_properties_dup_id set new_unit_number = null where new_unit_number = '-1';
update new_properties_dup_id set new_street_number = null where new_street_number = '-1';
update new_properties_dup_id set new_street_name = null where new_street_name = '-1';
update new_properties_dup_id set new_street_direction = null where new_street_direction = '-1';