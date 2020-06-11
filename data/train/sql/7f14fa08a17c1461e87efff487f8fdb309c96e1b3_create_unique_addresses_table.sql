-- change null values to -1 in new_properties table
update new_properties set new_street_direction = '-1' where new_street_direction is null or new_street_direction = '';
update new_properties set new_unit_number = '-1' where new_unit_number is null or new_unit_number = '';
update new_properties set new_street_number = '-1' where new_street_number is null or new_street_number = '';
update new_properties set new_street_name = '-1' where new_street_name is null or new_street_name = '';
update new_properties set new_street_direction = '-1' where new_street_direction is null or new_street_direction = '';

-- drop table unique addresses, if exist
drop table unique_addresses;

-- create table with all unique addresses
create table unique_addresses as
select distinct on (new_street_number, new_street_name , new_street_direction, new_unit_number, city_id) id dup_id, new_street_number, new_street_name, new_street_direction, new_unit_number, city_id 
from new_properties;