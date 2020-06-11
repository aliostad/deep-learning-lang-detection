require(['router/router', 'Controller/addController', 'Controller/listController', 'Controller/eventController', 'Controller/placesController', 'Controller/editController'], 
	
	function(Router, addController, listController, eventController, placesController, editController) {
	var route = new Router();
	route.addRoute('#addEvent', addController.init);
	route.addRoute('#list', listController.init);
	route.addRoute('#event/:id', eventController.init);
	route.addRoute('#places', placesController.init);
	route.addRoute('#event/edit/:id', editController.init);

	var updatestate = function() {
		var hash = window.location.hash || route.defaultRoute;
		window.location.hash = hash;
		route.changeState(hash);
	}

	$(window).on("load", updatestate())
	$(window).on("hashchange", updatestate)
})