update ir_cron set active = False;

update ir_module_module set state = 'uninstalled' where state = 'to upgrade';
update ir_module_module set state = 'to upgrade' where name = 'account_followup';

delete from ir_model_data where id in (select d.id from ir_model_data d left join ir_model_fields f on (f.id = d.res_id and d.model='ir.model.fields') where d.model='ir.model.fields' and f.id is null);

delete from ir_ui_view where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.ui.view'
);

delete from ir_model_fields where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model.fields'
);

delete from ir_ui_menu where id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.ui.menu'
);


delete from ir_model_constraint where model in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from ir_model_relation where model in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from jasper_document where model_id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);

delete from base_action_rule where model_id in 
(
select res_id 
from ir_model_data 
left join ir_module_module on ir_module_module.name = ir_model_data.module
where ir_module_module.state = 'uninstalled'
and ir_model_data.model = 'ir.model'
);


update crm_case_section set name = 'Compressors FR', code = 'COMP-A' where id = 1;

update maintenance_intervention set address_id = req.inst from 
(
select interv.id interv, inst.id inst 
from maintenance_intervention interv 
left join maintenance_installation inst on interv.installation_id = inst.id
where interv.address_id != inst.address_id
) req
where req.interv = maintenance_intervention.id;

/*update ir_module_module set state = 'uninstalled' where name ilike 'elneo%';
update ir_module_module set state = 'uninstalled' where name ilike 'technofluid%';
update ir_module_module set state = 'uninstalled' where name ilike 'maintenance%';
update ir_module_module set state = 'uninstalled' where author ilike '%elneo%';
update ir_module_module set state = 'uninstalled' where author ilike '%technofluid%';*/
