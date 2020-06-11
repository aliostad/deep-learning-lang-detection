Ext.define('Base.view.diy_service.DiyServiceDetail', {
	
	extend : 'Base.abstract.entity.DetailMainView',
	
 	requires : [ 
		'Base.view.diy_service.DiyServiceForm',
		'Base.view.diy_service.DiyServiceInParams',
		'Base.view.diy_service.DiyServiceOutParams',
		'Base.view.diy_service.DiyServiceTest'],
	
	xtype : 'base_diy_service_detail',
	
	title : T('title.entity_details', {entity : T('title.diy_service')}),
	
	items : [ {
		xtype : 'base_diy_service_form'
	}, {
		xtype : 'base_diy_service_in_params_list'
	}, {
		xtype : 'base_diy_service_out_params_list'
	}, {
		xtype : 'base_diy_service_test'
	} ]
});