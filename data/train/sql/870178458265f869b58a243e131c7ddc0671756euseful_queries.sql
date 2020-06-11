
select * from grasp where hand_name='SHADOW_HAND';

select * from original_model 
where original_model_id in 
(select original_model_id from scaled_model
where scaled_model_id in (select distinct scaled_model_id from grasp
where hand_name='SHADOW_HAND'));

select * from original_model 
where original_model_id in 
( select original_model_id from scaled_model
where scaled_model_id=18744);

;;create a new model set which contains only the coke can.
insert into model_set(model_set_name,original_model_id)
values ('SHADOW_DEBUG',9387)

#latest grasp (seen working on the coke can - seems very stable)
insert into grasp
(grasp_id,scaled_model_id,grasp_pregrasp_joints,grasp_grasp_joints,grasp_energy,grasp_pregrasp_position,grasp_grasp_position,grasp_source_id,grasp_pregrasp_clearance,grasp_cluster_rep,hand_name,grasp_table_clearance,grasp_compliant_copy,grasp_compliant_original_id,grasp_scaled_quality,fingertip_object_collision)
select 1717999,18744,'{-14,0,0,14,0,0,-10,0,0,0,-10,0,0,0,70,0,0,0}','{-14,33,66,14,40,61,-10,35,50,10,-10,45,70,15,70,0,5,5}',1,'{-0.075,-0.06,0.31,0.321,0.542,0.628,0.456}','{-0.05,-0.05,0.19,0.321,0.542,0.628,0.456}',4,0,true,'SHADOW_HAND',0,false,-1,1,false
