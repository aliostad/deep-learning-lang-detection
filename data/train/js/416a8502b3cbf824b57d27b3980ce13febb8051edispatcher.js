const HomeControllerModule = require('./homeController');
const StudentsControllerModule = require('./studentsController');

class Dispatcher {
  constructor(routes){
    this.controllers = {
      homeController: new HomeControllerModule.HomeController(this),
      studentsController: new StudentsControllerModule.StudentsController(this)
    };
    this.routes = routes;
  }

  dispatch(request){
    let controllerName, actionName;
    [controllerName, actionName] = this.routes[request.route].split('#');
    this.controllers[controllerName][actionName](request.parameters);
  }
}

module.exports.Dispatcher = Dispatcher;
