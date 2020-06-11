(function (controllers) {
        var homeController = require("./homeController");
        var adminController = require("./adminController");
        var boardController = require("./boardController");
        var testEmitterController = require("./testEmitterController");
        controllers.init = function (app) {
            homeController.init(app);
            adminController.init(app);
            boardController.init(app);
            testEmitterController.init(app);
        };

})(module.exports);