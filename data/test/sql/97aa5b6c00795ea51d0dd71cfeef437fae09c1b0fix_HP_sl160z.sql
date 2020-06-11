update machine_specs set memory=49152 where model_id = (
    select id from model where name='sl160z');
commit;

select count(1) from machine where machine_id in (
    select id from hardware_entity where model_id = (
        select id from model where name='sl160z') and memory=12288);

update machine set memory=49152 where machine_id in (
    select id from hardware_entity where model_id = (
        select id from model where name='sl160z'));

select count(1) from machine where machine_id in (
    select id from hardware_entity where model_id = (
        select id from model where name='sl160z') and memory=12288);

commit;
