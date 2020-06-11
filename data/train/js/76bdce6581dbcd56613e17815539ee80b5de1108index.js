 (function(controllers) {
    var authController = require("./authController");
    var locationController = require("./locationController");
    var usersController = require("./usersController");
    var layersController = require("./layersController");
    var weatherController = require("./weatherController");

    controllers.init = function(app) {
        authController.init(app);
        locationController.init(app);
        usersController.init(app);
        layersController.init(app);
        weatherController.init(app);
    };
})(module.exports);