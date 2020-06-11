var api = require('./controllers/api_controller');

module.exports = function (app) {
	// Get all users
	app.get('/api/users', api.hasEmailToken, api.userExists, api.validEmailToken, api.getUsers);

	// Add a new user
	app.post('/api/users', api.hasEmailPassword, api.userNotPresent, api.postUsers);

	// Retrieve user's token
	app.post('/api/users/auth', api.hasEmailPassword, api.userExists, api.validEmailPassword, api.auth);

	// Retrieve current user info
	app.get('/api/users/me', api.hasEmailToken, api.userExists, api.validEmailToken, api.getUser);

	// Update current user info
	app.put('/api/users/me', api.hasEmailToken, api.userExists, api.validEmailToken, api.putUser);

	// Delete current user
	app['delete']('/api/users/me', api.hasEmailToken, api.userExists, api.validEmailToken, api.deleteUser);
};
