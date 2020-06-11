var usersController = require('../controllers/controller');
var carsController = require('../controllers/carsController');
var makesController = require('../controllers/MakesController');
var categoriesController = require('../controllers/CategoriesController');
var modelsController = require('../controllers/ModelsController');
var colorsController = require("../controllers/colorsController");
var engineTypesController = require("../controllers/engineTypesController");
var gearboxTypesController = require("../controllers/gearboxTypesController");
var regionsController = require("../controllers/regionsController");

module.exports = {
    users: usersController,
    cars: carsController,
    makes: makesController,
    categories: categoriesController,
    models: modelsController,
    colors: colorsController,
    engineTypes: engineTypesController,
    gearboxTypes: gearboxTypesController,
    regions: regionsController
};