module.exports = function(app) {
	var HomerController = require('../controllers/HomeController.js')(app);
	var AuthenticationController = require('../controllers/AuthenticationController.js')(app);
	var ProjectsController = require('../controllers/ProjectsController.js')(app);
	var ReleasesController = require('../controllers/ReleasesController.js')(app);
	var CardsController = require('../controllers/CardsController.js')(app);

	return {
		HomerController: HomerController,
		AuthenticationController: AuthenticationController,
		ProjectsController: ProjectsController,
		ReleasesController: ReleasesController,
		CardsController: CardsController
	}
};