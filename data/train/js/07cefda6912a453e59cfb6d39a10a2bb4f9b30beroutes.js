var async = require('async');

module.exports = function(app) {

    //Home route
    var index = require('../app/controllers/index');
    app.get('/', index.render);
    app.get('/projects/:id', index.render);

    //API
  	var api = require('../app/controllers/api');

    app.get('/api/storylines-expanded/:id', api.storylinesExpanded.get);

  	app.get('/api/storylines', api.storylines.list);
  	app.post('/api/storylines', api.storylines.create);
  	app.get('/api/storylines/:id', api.storylines.get);
  	app.delete('/api/storylines/:id', api.storylines.delete);
  	app.put('/api/storylines/:id', api.storylines.update);

    app.get('/api/projects', api.projects.list);
    app.post('/api/projects', api.projects.create);
    app.get('/api/projects/:id', api.projects.get);
    app.delete('/api/projects/:id', api.projects.delete);
    app.put('/api/projects/:id', api.projects.update);

    app.get('/api/newsitems', api.newsItems.list);

    app.get('/api/topics', api.topics.list);

};