var app, api;

var init = function (appInstance) {
  app = appInstance;
  api = app.api.v1;

  setupRoutes();
};

var setupRoutes = function () {
  app.get('/api/v1/groups', api.groups.browse);
  app.get('/api/v1/groups/:groupId', api.groups.read);
  app.put('/api/v1/groups/:groupId', api.groups.edit);
  app.post('/api/v1/groups', api.groups.add);
  app.delete('/api/v1/groups/:groupId', api.groups.delete);

  app.get('/api/v1/groups/:groupId/items', api.items.browse);
  app.get('/api/v1/items', api.items.browse);
  app.get('/api/v1/items/:itemId', api.items.read);
  app.put('/api/v1/items/:itemId', api.items.edit);
  app.post('/api/v1/items', api.items.add);
  app.delete('/api/v1/items/:itemId', api.items.delete);
  app.patch('/api/v1/items/:itemId', api.items.edit);
};

module.exports = {
  init: init,
};
