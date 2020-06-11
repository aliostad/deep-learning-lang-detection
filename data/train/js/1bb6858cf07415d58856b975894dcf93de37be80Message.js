/**
 * Message controller
 */
Ext.define('Base.controller.message.Message', {
	
	extend : 'Frx.controller.ListController',
	
	requires : [ 
		'Base.model.Message', 
		'Base.store.Message', 
		'Base.view.message.Message' 
	],
	
	models : ['Base.model.Message'],
			
	stores : ['Base.store.Message'],
	
	views : ['Base.view.message.Message'],
		
	init : function() {
		this.callParent(arguments);
		
		this.control({
			'base_message' : this.EntryPoint(),
			'base_message #goto_item' : {
				click : this.onGotoItem
			}
		});
	}

});