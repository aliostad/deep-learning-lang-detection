update machine_specs set memory=49152 where model_id = (select id from model where name='dx360-7323ac1');
commit;

select count(1) from machine where machine_id in (select id from hardware_entity where model_id = (select id from model where name='dx360-7323ac1') and memory=65536);

update machine set memory=49152 where machine_id in (select id from hardware_entity where model_id = (select id from model where name='dx360-7323ac1'));

select count(1) from machine where machine_id in (select id from hardware_entity where model_id = (select id from model where name='dx360-7323ac1') and memory=65536);

commit;
