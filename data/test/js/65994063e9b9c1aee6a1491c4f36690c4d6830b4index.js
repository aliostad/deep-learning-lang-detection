/**
 * Created by djgLXXII on 8/7/2015.
 */
// index.js

(function (controllers) {

    var homeController = require('./homeController');
    var parserController = require('./parserController');
    var compareController = require('./compareController');
    var glossaryController = require('./glossaryController');

    controllers.init = function (app) {
        homeController.init(app);
        parserController.init(app);
        compareController.init(app);
        glossaryController.init(app);
    };

})(module.exports);