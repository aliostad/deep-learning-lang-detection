FirstApp.controller('CountryController', [ '$scope', 'crudService',
		function($scope, crudService) {
			var service = crudService('countries');

			$scope.entities = service.query();
			$scope.entity = {};

			$scope.edit = function(id) {
				$scope.entity = service.get({
					id : id
				});
			};

			$scope.save = function() {
				service.save($scope.entity, function(data) {
					$scope.entity = {};
					$scope.entities = service.query();
				});
			};

			$scope.remove = function(id) {
				service.remove({
					id : id
				}, function() {
					$scope.entities = service.query();
				});
			};

		} ]);
