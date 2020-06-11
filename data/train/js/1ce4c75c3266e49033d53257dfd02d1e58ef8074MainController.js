define([
	"jquery", "underscore", "backbone", "mvc",
	"controllers/HeaderController", "controllers/ToolbarController", "controllers/ProjectController", 
	"controllers/ComponentLibraryController", "controllers/CanvasController", "controllers/CodeController", "controllers/RunController",
	"controllers/PropertyController", "controllers/EventController", "controllers/StatusController",
	"views/MainView"
], function($, _, Backbone, MVC, 
		HeaderController, ToolbarController, ProjectController,
		ComponentLibraryController, CanvasController, CodeController, RunController,
		PropertyController, EventController, StatusController, 
		MainView) {
	var MainController = AppBuilder.Controller.extend({
		
		headerController: null,
		toolbarController: null,
		projectController: null,
		componentLibraryController: null,
		canvasController: null,
		codeController: null,
		propertyController: null,
		eventController: null,
		statusController: null,
		mobileController: null,
		runController: null,
		
		routes: {
			"": "showMainView"
		},
		
		initialize: function(node, parentController) {
			AppBuilder.Controller.prototype.initialize.call(this, node, parentController);
		},
		
		showMainView: function() {
			/*if(!$.browser.webkit) {
				alert("AppBuilder only supports the browsers that has WebKit core (e.g. Chrome, Baidu Browser, etc.)");
				return;
			}*/

			this.view = new MainView();
			this.node.append(this.view.$el);
			this.view.render();
			
			this.headerController = new HeaderController($("#header", this.node), this);
			this.toolbarController = new ToolbarController($("#toolbar", this.node), this);
			this.projectController = new ProjectController($("#project", this.node), this);
			this.componentLibraryController = new ComponentLibraryController($("#component", this.node), this);
			this.canvasController = new CanvasController($("#canvas", this.node), this);
			this.propertyController = new PropertyController($("#property", this.node), this);
			this.eventController = new EventController($("#event", this.node), this);
			this.statusController = new StatusController($("#status", this.node), this);
			this.codeController = new CodeController(null, this);
			this.runController = new RunController($("body"), this);

			this.headerController.showView();
			this.toolbarController.showView();
			this.projectController.showView();
			this.componentLibraryController.showView();
			this.canvasController.showView();
			this.runController.showView();
			this.propertyController.showView();
			this.eventController.showView();
			this.statusController.showView();
			this.codeController.showView();
			
			this.view.pass("onCloseTab", this.codeController);
		},
		
		setMobileController: function(controller) {
			this.mobileController = controller;
			this.trigger("onMobileReady");
		},
		
		activateProjectView: function() {
			
		},
		
		activateComponentView: function() {
			
		},
		
		activateCanvasView: function() {
			
		},
		
		activateCodeView: function() {
			this.view.activateCodeView();
		},
		
		activatePropertyView: function() {
			
		},
		
		activateEventView: function() {
			
		},
		
		createCodeViewNode: function(tabID) {
			return this.view.createCodeViewNode(tabID);
		},
		
		addCodeView: function(tabID, title, view) {
			this.view.addCodeView(tabID, title, view);
		},
		
		openCodeView: function(tabID) {
			this.view.openCodeView(tabID);
		},
		
		removeCodeView: function(tabID) {
			this.view.removeCodeView(tabID);
		},
		
		disableLeavePretection: function() {
			this.view.disableLeavePretection();
		}
	});
	return MainController;
});