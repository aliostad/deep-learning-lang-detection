Ext.define('Base.view.diy_service.DiyServiceItem', {
	
	extend : 'Ext.tab.Panel',
	
 	requires : [ 
		'Base.view.diy_service.DiyServiceForm',
		'Base.view.diy_service.DiyServiceInParams',
		'Base.view.diy_service.DiyServiceOutParams',
		'Base.view.diy_service.DiyServiceLogic',
		'Base.view.diy_service.DiyServiceTest'
	],
	
	xtype : 'base_diy_service_item',
	
	mixins : {
		spotlink : 'Frx.mixin.view.SpotLink'
	},
	
	title : T('menu.DiyService'),
	
	items : [ {
		xtype : 'base_diy_service_form'
	}, {
		xtype : 'base_diy_service_logic'
	}, {
		xtype : 'base_diy_service_in_params_list'
	}, {
		xtype : 'base_diy_service_out_params_list'
	}, {
		xtype : 'base_diy_service_test'
	} ]
});