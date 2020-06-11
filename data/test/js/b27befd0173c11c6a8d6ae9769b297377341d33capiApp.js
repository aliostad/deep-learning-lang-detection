/**
 * api app, provide api access
 * Created by B.HOU on 8/19/2014.
 */

var api = require('../../routes/api');

function init(app) {
  // api for admin
  // TODO: add admin authentication
  app.get('/api/apps', api.listApps);
  app.post('/api/app', api.newApplication); // create a new application
  app.delete('/api/app', api.deleteApplication);  // delete an application

  // api for application
  app.post('/api/user', api.ensureAppAuthenticated, api.createUser);    // create user information
  app.delete('/api/user', api.ensureAppAuthenticated, api.removeUser);    // remove user
  app.delete('/api/appUserAttr', api.ensureAppAuthenticated, api.removeAppUserAttr);    // remove app user attr
  app.put('/api/userAttr', api.ensureAppAuthenticated, api.setUserAttr);   // update user information
  app.put('/api/appUserAttr', api.ensureAppAuthenticated, api.setAppUserAttr); // update app-user-attr
  app.get('/api/userAttr', api.ensureAppAuthenticated, api.getUserAttr); // get user attribute, including app user attribute
  app.get('/api/userInfo', api.ensureAppAuthenticated, api.getUserInfo);    // get user information
  app.get('/api/resetPwd', api.ensureAppAuthenticated, api.resetPassword); // GET reset user password

  // high level api, get predefined attributes
  app.get('/api/binding/:name', api.ensureAppAuthenticated, api.getBindingAttr);  // name could be wechat/phone/weibo/qq

  // api for authentication
  app.post('/api/login', api.ensureAppAuthenticated, api.login);   // get the login token
  app.post('/api/verify', api.ensureAppAuthenticated, api.verifyToken);  // verify if the user token is valide

  // deprecated
  app.get('/api/user/:id', api.ensureAppAuthenticated, api.getUserInfo);    // [GET]get user information
  app.post('/api/userinfo/:id', api.ensureAppAuthenticated, api.getUserInfo); // [POST] get user information
  app.put('/api/user/:id', api.ensureAppAuthenticated, api.setUserAttr);   // update user information
}

module.exports = {
  init: init
}