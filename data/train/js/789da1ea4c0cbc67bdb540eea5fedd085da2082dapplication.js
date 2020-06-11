define(["marionette", "backbone", "navigation/navigationController", "routes/home/homeController", "routes/idea/ideaController", "notification/notificationController"], function(Marionette, Backbone, NavigationController, HomeController, IdeaSaveController, NotificationController){
	var application = new Marionette.Application();
	application.addInitializer(function(options){
		application.addRegions({
			contentRegion: "#content",
			notificationRegion: "#notification",
			navigationRegion: "#navigation"
		});
		var navigationController = new NavigationController({
			navigationRegion: application.navigationRegion
		});
		var notificationController = new NotificationController({
			notificationRegion: application.notificationRegion
		});
		var homeController = new HomeController({
			contentRegion: application.contentRegion
		});
		var ideaSaveController = new IdeaSaveController({
			contentRegion: application.contentRegion,
			notificationController: notificationController
		});
		Backbone.history.start();
	});
	return application;
});