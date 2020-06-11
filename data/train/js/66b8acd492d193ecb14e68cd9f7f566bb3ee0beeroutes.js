
module.exports = function(app, passport) {

	// Controllers
	var api = require('./lib/controllers/api'),
    	controllers = require('./lib/controllers');


	//api routes
	app.get('/api/awesomeThings', api.awesomeThings);

	//users CRUD
	app.get('/api/users', api.usersReadList);
	app.post('/api/users', api.usersCreate);
	app.get('/api/users/:id', api.usersReadSingle);
	app.put('/api/users/:id', api.usersUpdate);
	app.delete('/api/users/:id', api.usersDelete);


	//user login and signup
	app.post('/api/login', api.loginSignup);
	app.post('/api/signup', api.loginSignup);


	//angular routes
	app.get('/partials/*', controllers.partials);
	app.get('/*', controllers.index);
};