// ROUTES //

module.exports.routes = {
    
    //PAGE CONTROLLER - GET
    'get /': 'PageController.index',
    'get /register': 'PageController.register',
    'get /login': 'PageController.login',
    'get /dashboard': 'PageController.dashboard',
    
    //AUTH CONTROLLER - GET
    'get /logout': 'AuthController.logout',
    
    //AUTH CONTROLLER - POST
    'post /register': 'AuthController.register',
    'post /login': 'AuthController.login',
    
    //APIKEY CONTROLLER - GET
    'get /addkey': "ApiKeyController.addKey",
    
    //APIKEY CONTROLLER - POST
    'post /addkey': 'ApiKeyController.doAddKey',
    
    //ADMIN CONTROLLER - GET
    'get /admin': 'AdminController.adminDesk',
    
    //CHARACTER CONTROLLER - GET
    'get /selectmain': 'CharacterController.selectMainCharacter',
    
    //CHARACTER CONTROLLER
    'post /selectmain': 'CharacterController.doSelectMainCharacter'
};
