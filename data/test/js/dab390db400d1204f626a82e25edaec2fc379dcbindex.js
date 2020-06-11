var mainController = require("./mainController");
var categoriesController = require("./categoriesController");
var subCategoriesController = require("./subCategoriesController");
var brandsController = require("./brandsController");
var productsController = require("./productsController");
var bannerController = require("./bannerController");
var uploadController = require("./uploadController");

var controllers = {};

controllers.init = function (app,dirname) {
    
    mainController.init(app);
    categoriesController.init(app);
    subCategoriesController.init(app);
    brandsController.init(app);
    productsController.init(app);
    bannerController.init(app);
    uploadController.init(app, dirname);
};

module.exports = controllers;