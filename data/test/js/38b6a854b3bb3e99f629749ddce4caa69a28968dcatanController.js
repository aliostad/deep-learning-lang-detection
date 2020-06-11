catanClient.controller.catanController = {

	init: function(resourceArray) {
		catanClient.controller.backgroundController.init();
		catanClient.controller.landController.init();
		catanClient.controller.resourceController.init();
		
		catanClient.controller.diceController.init();
		
		// TODO Paint
		this.paint(resourceArray);
	},

	paint: function(resourceArray) {
		// Should be visible when game start
		catanClient.controller.backgroundController.paint();
		catanClient.controller.landController.paint(resourceArray);
	}
		
};