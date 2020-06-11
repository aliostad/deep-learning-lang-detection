var DashboardController = require('../controller/DashboardController'),
    AuthController = require('../controller/AuthController')
    FieldController = require('../controller/FieldController'),
    UserController = require('../controller/UserController');

module.exports = function(app) {
    var defaultController = new DashboardController();
    var authController = new AuthController(passport);
    var fieldController = new FieldController();
    var userController = new UserController();

    app.get('/', defaultController.index);
    app.get('/login', authController.index);
    app.post('/login', authController.login);
    app.get('/logout', authController.logout);

    // field
    app.get('/field', fieldController.index);
    app.get('/field/delete', fieldController.delete);
    app.get('/field/create', fieldController.create);
    app.get('/field/edit', fieldController.edit);
    app.post('/field', fieldController.save);

    // user
    app.get('/user', userController.index);
    app.get('/user/delete', userController.delete);
    app.get('/user/create', userController.create);
    app.get('/user/edit', userController.edit);
    app.post('/user', userController.save);
};
