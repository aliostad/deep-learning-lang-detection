Ext.application({
	requires: ['Ext.container.Viewport', 'Ext.data.proxy.Rest', 'Ext.form.Panel'],
    name: 'MONITOR',
    appFolder: 'app',
    controllers:[
        'AgendamentoController',
        'LoginController',       
        'NoController',
        'SlaController',
        'InicioController',
        'JanelaSlaController',
        'ThresholdController',
        'UsuarioController',
        'BaseController',
        'GraficoController'
        
    ],
    launch: function() {
   
	    Ext.USE_NATIVE_JSON = true;
	    
	    Ext.create('Ext.container.Viewport', {
	            layout: 'fit',
	            renderTo: Ext.getBody(),
	            items: [
	                {
	                    xtype: 'loginform'
	                }
	            ],
	
	    });
    }
});