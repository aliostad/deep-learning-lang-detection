
function Controller(app) {
	this.RootController = require("./root_controller")(app);
	this.UserController = require("./user_controller")(app);
	this.AuthController = require("./auth_controller")(app);
	this.RestaurantController = require("./restaurant_controller")(app);
	this.OrderController = require("./order_controller")(app);
	this.MealController = require("./meal_controller")(app);
	this.SuprizController = require("./supriz_controller")(app);
	this.ErrorController = require("./error_controller");
}

var _controller = false;
module.exports = _controller || function(app) {
	_controller = new Controller(app);
	return _controller;
}

/** CONTROLLER TEMPLATE

function {TEMPLATE}Controller() {

	this.getStatus = function(req, res, next) {
		return {
			"status" : "OK"
		};
	};
}

module.exports = function(app) {
	
	var controller = new {TEMPLATE}Controller();

	app.get("/", function(req, res, next) {
		// res.json();
	});

	return controller;
}

**/