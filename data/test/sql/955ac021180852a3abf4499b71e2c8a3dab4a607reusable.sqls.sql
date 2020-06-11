truncate table new_mp_2
insert into new_mp_2 select attribute.id as attribute_id,new_mp.* from seed, attribute, new_mp where seed.seed_id = new_mp.seed_id && attribute.id = seed.attribute_id
truncate table new_mp_3
insert into new_mp_3 select forges.forge_id as forge_id,new_mp_2.* from projects, forges, new_mp_2 where projects.proj_id = new_mp_2.project_id && projects.forge_id = forges.forge_id
truncate table new_mp_4
insert into new_mp_4 select alias.id as alias_id,new_mp_3.* from alias, new_mp_3 where alias.forge_id = new_mp_3.forge_id && alias.attribute_id = new_mp_3.attribute_id
truncate table new_mp_5
insert into new_mp_5 select count(*) as support, alias_id, path, id from new_mp_4 group by new_mp_4.alias_id,new_mp_4.path
TRUNCATE table max_mp
insert into max_mp select * from new_mp_5 x where (x.support, x.alias_id) in (select max(support),alias_id from new_mp_5 group by alias_id)