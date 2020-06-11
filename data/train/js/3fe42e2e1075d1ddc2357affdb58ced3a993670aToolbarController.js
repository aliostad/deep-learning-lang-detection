define([
	"jquery", "underscore", "backbone", "mvc", 
	"views/ToolbarView"
], function($, _, Backbone, MVC, ToolbarView) {
	var ToolbarController = AppBuilder.Controller.extend({
		
		initialize: function(node, parentController) {
			AppBuilder.Controller.prototype.initialize.call(this, node, parentController);
		},
		
		showView: function() {
			this.view = new ToolbarView();
			this.view.pass("onNewProject", this.parentController.projectController);
			this.view.pass("onOpenProject", this.parentController.projectController);
			this.view.pass("onSaveProject", this.parentController.projectController);
			this.view.pass("onCloseProject", this.parentController.projectController);
			this.view.pass("onRemoveProject", this.parentController.projectController);
			this.view.pass("onSetupProject", this.parentController.projectController);
			this.view.pass("onNewPage", this.parentController.projectController);
			
			this.view.pass("onUndo", this.parentController.projectController);
			this.view.pass("onRedo", this.parentController.projectController);
			this.view.pass("onRemovePage", this.parentController.projectController);
			this.view.pass("onCopyComponent", this.parentController.projectController);
			this.view.pass("onCutComponent", this.parentController.projectController);
			this.view.pass("onPasteComponent", this.parentController.projectController);
			this.view.pass("onRemoveComponent", this.parentController.projectController);
			
			this.view.pass("onRunProject", this.parentController.projectController);
			this.view.pass("onDeployProject", this.parentController.projectController);
			this.view.pass("onTestProject", this.parentController.projectController);
			this.node.append(this.view.$el);
			this.view.render();
		},
		
		enableUndo: function(isEnabled) {
		
		},
		
		enableRedo: function(isEnabled) {
		
		}
});
	return ToolbarController;
});