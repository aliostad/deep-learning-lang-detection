var api = require('../controllers/api');

module.exports.initialize = function(app) {

  app.get('/api/home', api.home);
  app.get('/api/items', api.all);
  app.get('/api/items/:id', api.single);
  app.get('/api/categories', api.categories);
  app.get('/api/category/:name', api.category);
  app.get('/api/autocomplete', api.autocomplete);

  app.post('/api/items', api.insert);

  // images
  app.post('/api/upload', api.upload);
  app.get('/api/remove/:id', api.remove);

  app.put('/api/items/:id', api.update);

  app.delete('/api/items/:id', api.delete);
  app.delete('/api/category/:name/:id', api.delete);

};