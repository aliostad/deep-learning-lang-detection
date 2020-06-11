module("BacklogController", {
	setup: function() {
		addBacklogAndTestDataCreationMethods(this);
		$('#test-container').append('<div class="main" id="backlog"/>');
	},
	teardown: function() {
		BacklogController.callbacksForDidLoad = [];
		BacklogController.callbacksForAfterRendering = [];
		$('#test-container')[0].innerHTML = '';
	}
});

test("gets error message when an error happen during loading with BacklogServerCommunicator", function() {
	expect(1);
	var controller = new BacklogController();
	controller.setMessage = function(errorMessage) {
		equals('fnord', errorMessage);
	};
	controller.model.loader.showError('fnord');
});

test("can register for callback after backlog loading", function() {
	var firstSensedController = null;
	BacklogController.registerForCallbackAfterLoad(function(controller){
		firstSensedController = controller;
	});
	var secondSensedController = null;
	BacklogController.registerForCallbackAfterLoad(function(controller){
		secondSensedController = controller;
	});
	equals(firstSensedController, null);
	equals(secondSensedController, null);
	
	var controller = new BacklogController();
	controller.didLoadBacklog();
	equals(firstSensedController, controller);
	equals(secondSensedController, controller);
});

// REFACT: move the backlogcontroller to the setup...