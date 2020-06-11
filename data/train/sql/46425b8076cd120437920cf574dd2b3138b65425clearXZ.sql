
--如果模块卸载不干净可以尝试以下SQL语句清理

--模块 字段 Sql约束
select * from ir_model_fields where model like 'xz.%';
select * from ir_model_constraint where model in (select id from ir_model where model like 'xz.%');
select * from ir_model_relation where model in (select id from ir_model where model like 'xz.%');
select * from ir_model where model like 'xz.%';

--视图 动作
select * from ir_ui_view where model like 'xz.%';
select * from ir_act_window where res_model like 'xz.%';

--
select * from ir_act_window_view where view_id in (select id from ir_ui_view where model like 'xz.%');
select * from ir_act_window_view where act_window_id in (select id from ir_act_window where res_model like 'xz.%');


--
select * from ir_ui_menu order by id desc limit 50;
select * from ir_values order by id desc limit 50;


--清除数据
delete from ir_model_fields where model like 'xz.%';
delete from ir_model_constraint where model in (select id from ir_model where model like 'xz.%');
delete from ir_model_relation where model in (select id from ir_model where model like 'xz.%');
delete from ir_model where model like 'xz.%';

delete from ir_act_window where res_model like 'xz.%';
delete from ir_ui_view where model like 'xz.%';