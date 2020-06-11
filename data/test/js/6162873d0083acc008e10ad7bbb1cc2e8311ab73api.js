var apiController = require('../controllers/apiController');
 
module.exports = function(app, passport) {

  app.route('/api/v1/users')
    .get(apiController.getUsers)
    .post(apiController.postUsers);

  app.route('/api/v1/users/:id')
    .get(apiController.getUserById)
    .put(apiController.putUserById)
    .delete(apiController.deleteUserById);



//  app.route('/api/v1/login')
//    .post(apiController.postLogin);

//  app.route('/api/v1/logout')
//    .post(apiController.postLogout); 

//  app.route('/api/v1/oauth2/login')
//    .get(apiController.getOAuth);
//    .post(apiController.postOAuth);

//  app.route('/api/v1/oauth2/code')
//    .get(apiController.getOAuthCode);

//  app.route('/api/v1/users/:id/providers')
//    .get(apiController.getProviders);

//  app.route('/api/v1/users/:id/providers/:index')
//    .get(apiController.getProviderIndex);
//    .delete(apiController.deleteProvider);

//  app.route('/api/v1/oauth2/link')
//    .get(apiController.getOAuthLink);


};
