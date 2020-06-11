define([
    'web/controller/applicationController',
    'web/controller/signInController',
    'web/controller/userController',
    'web/controller/dashboardController',

    'web/model/applicationModel',
    'web/model/signInModel',
    'web/model/userModel',
    'web/model/dashboardModel'
], function(
    applicationController,
    signInController,
    userController,
    dashboardController,

    applicationModel,
    signInModel,
    userModel,
    dashboardModel
) {
    var controllersMap = {};

    function router(name) {
        return controllersMap[name];
    }

    function bindController(name, controllerClass, modelClass) {
        modelClass.prototype = {
            controller: function() {
                return controllersMap[name];
            }
        };
        var model = new modelClass();

        controllerClass.prototype = {
            model: function() {
                return model;
            },
            router: router
        };
        controllersMap[name] = new controllerClass();
    }

    return {
        init: function() {
            bindController('application', applicationController, applicationModel);
            bindController('signIn', signInController, signInModel);
            bindController('user', userController, userModel);
            bindController('dashboard', dashboardController, dashboardModel);
        },
        controller: router
    };
});