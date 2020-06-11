drop table c3p0_test_table;

alter table scene change state_persistence old_state_persistence char(1);
alter table scene change reset_action old_reset_action char(1);

alter table scene_condition change action_type old_action_type char(1);
alter table scene_action_condition change action_type old_action_type char(1);

alter table scene_condition change time_after_before old_time_after_before char(1);
alter table scene_action_condition change time_after_before old_time_after_before char(1);

alter table scene_condition change time_when old_time_when char(1);
alter table scene_action_condition change time_when old_time_when char(1);

alter table scene_condition change time_plus_minus old_time_plus_minus char(1);
alter table scene_action_condition change time_plus_minus old_time_plus_minus char(1);

alter table scene_condition change scene_group_on_off old_scene_group_on_off char(1);
alter table scene_action_condition change scene_group_on_off old_scene_group_on_off char(1);

alter table scene_condition change action old_action char(1);

alter table scene_action_condition change scene_state old_scene_state char(1);
alter table scene_action_condition change action old_action char(1);

alter table scene_action change type old_type char(1);

alter table scene_activation change group_on_action old_group_on_action char(1);
alter table scene_activation change group_off_action old_group_off_action char(1);
