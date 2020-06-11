/*
Creating this as one file for now
*/

App.ApplicationController = Em.Controller.extend();

App.NavigationController = Em.Controller.extend();

App.IndexController = Em.Controller.extend();

App.PlayersController = Em.ArrayController.extend(); 

App.ConsoleController = Em.ArrayController.extend(); 

App.PluginsController = Em.ArrayController.extend();

App.WorldsController = Em.ArrayController.extend();

App.Players_widgetController = Em.ArrayController.extend({
	isLoading: function() {
		return App.players.get('loading');
	}.property('App.players.loading')
});

App.Console_widgetController = Em.ArrayController.extend({
	isLoading: function() {
		return App.console.get('loading');
	}.property('App.console.loading')
});

App.Stats_widgetController = Em.ObjectController.extend();
