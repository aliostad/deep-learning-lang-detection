/* Services */

angular.module('appNameService', []).service('NameService', function() {
	this.getName = function() {
		return "Ashish";
	};
});

angular.module('appAboutService', []).service('AboutService', function() {
	this.getAbout = function() {
		return "Neevtech : Learning Angular JS";
	};
});

angular.module('appExperimentService', []).service('ExperimentService',
		function() {
			this.getExperiment = function() {
				return "Angular-JS";
			};
		});

angular.module('appHomeService', []).service('HomeService', function() {
	this.getHome = function() {
		return "INDIA";
	};
});
