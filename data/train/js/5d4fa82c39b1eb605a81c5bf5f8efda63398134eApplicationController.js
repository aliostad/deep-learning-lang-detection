/** @constructor */
MusicXMLAnalyzer.ApplicationController = function() {

	var that = {},
	headerController = null,
	uploadController = null,
	dashboardController = null,
	patternController = null,
	resultController = null,
	scoreController = null,

	/**
	 * Init function of ApplicationController
	 * @function
     * @public
	 */
	init = function() {
		headerController = MusicXMLAnalyzer.HeaderController();
		headerController.init();
		uploadController = MusicXMLAnalyzer.UploadController();
		uploadController.init();

		if (Route.check('/dashboard')) {
			dashboardController = MusicXMLAnalyzer.DashboardController();
			dashboardController.init();
		}

		if (Route.check('/pattern')) {
			patternController = MusicXMLAnalyzer.PatternController();
			patternController.init();
		}

		if (Route.check('/results')) {
			resultController = MusicXMLAnalyzer.ResultController();
			resultController.init();
		}

		if (Route.check('/score')) {
			scoreController = MusicXMLAnalyzer.ScoreController();
			scoreController.init();
		}
	};

	that.init = init;

	return that;
};
