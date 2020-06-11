CREATE INDEX sr_work_unit_index_on_rowidentifier
  ON cadastre.sr_work_unit
  USING btree
  (rowidentifier);


-- DROP INDEX cadastre.sr_work_unit_index_on_name;

CREATE INDEX sr_work_unit_index_on_name
  ON cadastre.sr_work_unit
  USING btree
  (name);


insert into cadastre.sr_work_unit(id, name, rowidentifier, change_user,rowversion) 
select new.id, new.name, new.rowidentifier, new.change_user, new.rowversion from cadastre.spatial_unit_group new
where new.id not in (select srwu.id from cadastre.sr_work_unit srwu) and new.hierarchy_level = 4;    


update cadastre.sr_work_unit swu set name = (select new.name from cadastre.spatial_unit_group new
where new.id = swu.id and new.hierarchy_level = 4);    


