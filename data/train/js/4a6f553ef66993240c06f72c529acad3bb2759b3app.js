var TestApp = new Marionette.Application();

TestApp.addRegions({
	mainRegion: "#main-region"
});

TestApp.navigate = function(route, options){
	options || (options = {});
	Backbone.history.navigate(route, options);
};

TestApp.getCurrentRoute = function(){
	return Backbone.history.fragment
};

TestApp.on("start", function(){
	if(Backbone.history){
		Backbone.history.start();
		if(this.getCurrentRoute() === ""){
			this.navigate("foo");
			TestApp.MyApp.Show.Controller.ShowFoo();
		}
	}
});

TestApp.module("MyApp", function(App, TestApp, Backbone, Marionette, $, _) {
	App.Router = Marionette.AppRouter.extend({
		appRoutes: {
			"foo": "ShowFoo",
			"bar": "ShowBar",
			"baz": "ShowBaz"
		}
	});
	
	var API = {
		ShowFoo: function(){
			App.Show.Controller.ShowFoo();
		},
		ShowBar: function(){
			App.Show.Controller.ShowBar();
		},
		ShowBaz: function(){
			App.Show.Controller.ShowBaz();
		}
	};
	
	TestApp.addInitializer(function(){
		new App.Router({
			controller: API
		});
	});
});

TestApp.module("MyApp.Show", function(Show, App, Backbone, Marionette, $, _)
{
	Show.FooLayoutView = Backbone.Marionette.LayoutView.extend({
		template: "#templates-foo",
		tagName: "span"
	});
	Show.BarLayoutView = Backbone.Marionette.LayoutView.extend({
		template: "#templates-bar",
		tagName: "span"
	});
	Show.BazLayoutView = Backbone.Marionette.LayoutView.extend({
		template: "#templates-baz",
		tagName: "span"
	});

	var ContactsShowController = Marionette.Controller.extend({
		ShowFoo: function()
		{
			this.fooView = new Show.FooLayoutView();
			
			App.mainRegion.show(this.fooView);
		},
		ShowBar: function()
		{
			this.barView = new Show.BarLayoutView();
			
			App.mainRegion.show(this.barView);
		},
		ShowBaz: function()
		{
			this.bazView = new Show.BazLayoutView();
			
			App.mainRegion.show(this.bazView);
		}
	});
	Show.Controller = new ContactsShowController;
});

$(function() {
	TestApp.start();
});