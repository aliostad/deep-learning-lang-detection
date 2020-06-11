var mainController = require('./controllers/mainController');
var apiController = require('./controllers/apiController');

module.exports = function (app) {
	
	/**
	 * API routes
	 */
	app.route('/api/todos')
		.get(apiController.todos)
		.post(apiController.addTodo)
		.put(apiController.updateTodo);
	
	/**
	 * Site routes
	 */
	app.route('/')
		.get(mainController.all);
	
	app.route('/all')
		.get(mainController.all);
	
	app.route('/active')
		.get(mainController.active);
	
	app.route('/completed')
		.get(mainController.completed);
	
	app.route('/add')
		.post(mainController.addTodo);
	
	app.route('/update')
		.post(mainController.updateTodo);
	
};