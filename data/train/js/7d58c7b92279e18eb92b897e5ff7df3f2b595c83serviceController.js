Ext.define('menu.controller.serviceController', {
    extend: 'Ext.app.Controller',

    config: {
        refs: {
        	serviceContainer: 'serviceContainer',
            services: 'services',
            storeServiceView:'storeServiceView'
        },

        control: {
            services: {
                itemtap: 'onServiceSelect'
            } 
        }
    },
 
    onServiceSelect: function(list, index, node, record) {
         
        if (!this.storeServiceView) {
            this.storeServiceView = Ext.create('menu.view.service.storeServiceView');
        }
        this.storeServiceView.setRecord(record);
        this.getServiceContainer().push(this.storeServiceView);
    } 
 
});
