function Router(container) {
}

Router.prototype.route = function (req, res) {
    var controllerClass     = 'ErrorController',
        action              = 'action404';

    try {
        switch (req.url) {
            case '':
            case '/':
            case '/home':
            case '/dashboard':
                controllerClass     = 'HomeController',
                action              = 'actionIndex';
                break;
        }

        var controller = require(__dirname + '/controllers/'+controllerClass+'.js');
        var controller = new controller();
        controller[action](req, res);
    } catch (e) {
        var controller = require(__dirname + '/controllers/ErrorController.js');
        controller = new controller();
        controller.action500(req, res, e);
    }
}

module.exports = Router;
