module.exports = function (app) {
  var api = require('./api/index');
  app.get('/', function (req, res) {
    res.redirect('./client');
  });

  app.get('/api/forum', api.forum);
  app.get('/api/global', api.global);
  app.get('/api/group', api.group);
  app.get('/api/site', api.site);
  app.get('/api/topic', api.topic);
  app.get('/api/user', api.user);
  app.post('/api/login', api.login);
  app.get('/api/gs', api.gs);
  app.get('/api/autoLogin', api.autoLogin);
  app.get('/test', function (req, res, next) {
    res.end(req.cookies.ngaCookie);
  });
};