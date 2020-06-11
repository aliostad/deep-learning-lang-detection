module.exports = angular.module('core',[])
		.controller('headerController', require('./controllers/headerController.js'))
		.controller('searchController', require('./controllers/searchController.js'))
		.controller('searchDialogController', require('./controllers/searchDialogController.js'))
		.controller('asideController', require('./controllers/asideController.js'))
		.controller('trainDialogController', require('./controllers/trainDialogController.js'))
		.factory('coreEventsService', require('./services/coreEventsService.js'))
		.factory('RestangularCustom', require('./services/restangularCustom.js'));
