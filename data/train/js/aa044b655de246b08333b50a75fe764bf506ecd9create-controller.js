module.exports = function (currentSpec) {
    return function (controllerName, scope) {
        var commons = require('./commons')(currentSpec), invoke = commons.getInvoke();

        return invoke(controllerFactory)(controllerName);

        function controllerFactory($controller) {
            return function (controllerName) {
                var createScope = commons.getCreateScope(),
                    localScope = createScope(scope),
                    controller = $controller(controllerName, {$scope: localScope});
                controller._scope = localScope;

                return controller;
            };
        }
    }
};
