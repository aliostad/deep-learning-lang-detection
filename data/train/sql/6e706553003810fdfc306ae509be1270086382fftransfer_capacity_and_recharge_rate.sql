/* 
 * 1) delete frontend
 * 2) update backend
 * 2.1) delete no longer needed models and controllers
 * 2.2) update RocketComponentController.php
 * 2.3) update RocketComponentModelController.php
 * 2.4) update RocketComponentModelMmController.php
 * 3) run sql-statement
 * 3.1) add new cannon-model to rocket_component_models
 * 4) update frontend
 */

UPDATE rocket_component_model_mm as target

inner join
(
	SELECT rocketComponent_id, max(capacity) as max_capacity FROM rocket_component_model_mm AS model_mm
	
	inner join rocket_component_model_level_mm as cap_level_mm
		on model_mm.rocketComponentModelCapacityLevelMm_id = cap_level_mm.id
	inner join rocket_component_model_levels as cap_level
		on cap_level_mm.rocketComponentModelLevel_id = cap_level.id
	
	where model_mm.`status` = 'unlocked' and cap_level_mm.status = 'unlocked'
	
	group by rocketComponent_id
)
as source
	on target.rocketComponent_id = source.rocketComponent_id
	
inner join rocket_component_models as model
	on target.rocketComponentModel_id = model.id
	
set target.capacity = source.max_capacity
	
where model.model = 1;



UPDATE rocket_component_model_mm as target

inner join
(
	SELECT rocketComponent_id, max(recharge_rate) as max_recharge_rate FROM rocket_component_model_mm AS model
	
	inner join rocket_component_model_level_mm as re_level_mm
		on model.rocketComponentModelRechargeRateLevelMm_id = re_level_mm.id
	inner join rocket_component_model_levels as re_level
		on re_level_mm.rocketComponentModelLevel_id = re_level.id
	
	where model.`status` = 'unlocked' and re_level_mm.status = 'unlocked'
	
	group by rocketComponent_id
)
as source
	on target.rocketComponent_id = source.rocketComponent_id
	
inner join rocket_component_models as model
	on target.rocketComponentModel_id = model.id

set target.recharge_rate = source.max_recharge_rate

where model.model = 1;



UPDATE rocket_component_model_mm as target
	
inner join rocket_component_models as model
	on target.rocketComponentModel_id = model.id
	
SET target.status = 'locked', capacity = 3, recharge_rate = 1
	
where model.model <> 1;



UPDATE rocket_components as component

inner join rocket_component_model_mm as mm
	on component.id = mm.rocketComponent_id
	
SET component.selectedRocketComponentModelMm_id = mm.id
	
where mm.status = 'unlocked'
