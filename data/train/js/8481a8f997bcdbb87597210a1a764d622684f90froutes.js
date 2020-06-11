module.exports = function(app){

		// Our model controllers (rather than routes)
		var application_controller = require('./controllers/application_controller');
		var character_controller = require('./controllers/character_controller');
		var user_controller = require('./controllers/user_controller');
		var truck_controller = require('./controllers/truck_controller');

		app.use('/', application_controller);
		app.use('/characters', character_controller);
		app.use('/users', user_controller);
		app.use('/trucks', truck_controller);

    //other routes..
}