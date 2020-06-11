OWF.View.Banner = Backbone.View.extend({

	el: $('#banner'),

	events: {
		'click .launchmenu-btn': 'showLaunchMenu',
		'click .dashboards-btn': 'showDashboardsWindow',
		'click .settings-btn': 'showSettings',
		'click .admin-btn': 'showAdminWindow',
	},
	
	showLaunchMenu: function (e) {
		this.trigger('show:launchmenu', e);
		return false;
	},

	showDashboardsWindow: function(e) {
		return false;
	},

	showSettings: function(e) {
		return false;
	},

	showAdminWindow: function(e) {
		return false;
	}
});