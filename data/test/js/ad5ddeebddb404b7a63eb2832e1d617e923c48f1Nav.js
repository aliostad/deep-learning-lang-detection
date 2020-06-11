Ext.define('Hatiopia.controller.Nav', {
    extend: 'Ext.app.Controller',
	
    config: {
        refs: {
            main : 'main',
            nav : 'nav',
            content : 'content',
			header : 'header'
        },

        control: {
			nav : {
				initialize : 'onInitialize',
				destroy : 'onDestroy' //TODO 이런 이벤트는 발생하지 않음. 처리 요망.
			},
			'#nav_admin' : {
				tap : 'onAdmin'
			},
			'#nav_resource' : {
				tap : 'onResource'
			},
			'#nav_blog' : {
				tap : 'onBlog'
			},
			'#nav_report' : {
				tap : 'onReport'
			}
        }
    },

	onInitialize: function() {
        var self = this;

        
    },

	onDestroy: function() {
        clearInterval(this.incidentInterval);
        clearInterval(this.vehicleMapInterval);
	},

    onAdmin: function(button, e) {
		this.getNav().setNavigationBar(true);
		this.getNav().push({
			xtype : 'nav_admin'
		});
    },

    onResource: function(button, e) {
		this.getNav().setNavigationBar(true);
		this.getNav().push({
			xtype : 'nav_resource'
		});
    },

	onBlog: function(button, e) {
		this.getNav().setNavigationBar(true);
		this.getNav().push({
			xtype : 'nav_blog'
		});
    },

	onReport: function(button, e) {
		this.getNav().setNavigationBar(true);
		this.getNav().push({
			xtype : 'nav_report'
		});
	}
});
