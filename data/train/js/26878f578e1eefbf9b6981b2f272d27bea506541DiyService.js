/**
 * DiyService controller
 */
Ext.define('Base.controller.diy_service.DiyService', {
	
	extend: 'Frx.controller.ListController',
		
	requires : [ 
		'Base.model.DiyService', 
		'Base.store.DiyService', 
		'Base.view.diy_service.DiyService' 
	],
		
	models : ['Base.model.DiyService'],
			
	stores: ['Base.store.DiyService'],
	
	views : ['Base.view.diy_service.DiyService'],
	
	init: function() {
		this.callParent(arguments);
		
		this.control({
			'base_diy_service' : this.EntryPoint(),
			'base_diy_service #goto_item' : {
				click : this.onGotoItem
			}
		});
	}

});