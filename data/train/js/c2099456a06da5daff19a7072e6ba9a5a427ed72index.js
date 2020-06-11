var wishListController = require('./wishListController');
var loginController = require('./loginController');
var detailController = require('./detailController');
var newController = require('./newController');
var aboutController = require('./aboutController');
var logoutController = require('./logoutController');

function install(app) {
    app.controller('wishListController', wishListController);
    app.controller('loginController', loginController);
    app.controller('detailController', detailController);
    app.controller('newController', newController);
    app.controller('aboutController', aboutController);
    app.controller('logoutController', logoutController);
}

module.exports.install = install;