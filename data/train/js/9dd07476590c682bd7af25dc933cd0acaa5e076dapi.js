var api = require('../api');
	
module.exports = function(server) {
	// Posts
	server.get('/admin/api/v0.1/posts/', api.requestHandler(api.posts.browse));
	server.get('/admin/api/v0.1/posts/:id', api.requestHandler(api.posts.read));
	server.put('/admin/api/v0.1/posts/:id', api.requestHandler(api.posts.edit));
	server.post('/admin/api/v0.1/posts/', api.requestHandler(api.posts.add));
	server.delete('/admin/api/v0.1/posts/:id', api.requestHandler(api.posts.destroy));

	//## Settings
    server.get('/admin/api/v0.1/settings/', api.requestHandler(api.settings.browse));
    server.get('/admin/api/v0.1/settings/:name/', api.requestHandler(api.settings.read));
    server.put('/admin/api/v0.1/settings/', api.requestHandler(api.settings.edit));

    // ## User
    server.get('/admin/api/v0.1/users/', api.requestHandler(api.users.browse));
    server.get('/admin/api/v0.1/users/:id/', api.requestHandler(api.users.read));
    server.put('/admin/api/v0.1/users/:id/', api.requestHandler(api.users.edit));
    server.post('/admin/api/v0.1/users/self/', api.requestHandler(api.users.add));
}
