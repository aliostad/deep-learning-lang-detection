MyApp.module("Nav", function(Nav, App, Backbone, Marionette, $_, _) {

	App.addRegions({
		sidebarRegion: "section.aside"
	});

	App.addInitializer(function(){
		Nav.navItems = new Nav.NavLinks(App.data.navItems);
		c = new Nav.SideNavController();
		App.vent.trigger("nav:showNav");
	});

	// side nav
	Nav.NavLink = Backbone.Model.extend({});
	Nav.NavLinks = Backbone.Collection.extend({
		model: Nav.NavLink
	});

	Nav.SideNavItemView = Backbone.Marionette.ItemView.extend({
		template: '#sidebar-nav-item',
		tagName: 'li',
		events: {
			'click a' : 'changePage'
		},
		changePage: function(e){
			e.preventDefault();
			App.vent.trigger('nav:changePage', this.model);
				MyApp.vent.trigger('notify:message', 'page changed: ' + this.model.get('text'));
		}
	});

	Nav.SideNavView = Backbone.Marionette.CompositeView.extend({
		template:'#sidebar-nav',
		itemView: Nav.SideNavItemView,
		itemViewContainer: 'ul',
		tagName: 'nav'
	});

	Nav.SideNavController = App.Controller.extend({
		initialize: function(options) {
			App.listenTo(App.vent, "nav:showNav", this.showNav, this);
		},

		showNav: function(){
			Nav.sideNavView = new Nav.SideNavView({
				collection: Nav.navItems
			});
			App.sidebarRegion.show(Nav.sideNavView);
		}
	});

});