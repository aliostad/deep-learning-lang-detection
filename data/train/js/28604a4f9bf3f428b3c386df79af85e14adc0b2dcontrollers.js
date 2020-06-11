var omnibrokerControllers = angular.module('omnibrokerControllers',
		[ 'ui.bootstrap' ]);

omnibrokerControllers.controller('ServiceListCtrl', [
		'$scope',
		'Service',
		'$modal',
		function($scope, Service, $modal) {

			function updateServiceList() {
				var services = Service.query(function() {
					if (services && services._embedded
							&& services._embedded.service)
					{
						$scope.services = services._embedded.service
					}
					else
						$scope.services = [];
				});
			};

			updateServiceList();

			$scope.editService = function(service, index) {
				serviceDialog(service, index);
			}

			$scope.addService = function() {
				serviceDialog({id: generateGUID(), plans:[], dashboard_client: {}, metadata: {}}, $scope.services.length);
			};
			
			function serviceDialog(service, index) {
				dlg = $modal.open({
					templateUrl : 'views/serviceEdit.html',
					controller : 'ServiceEditCtrl',
					resolve: {
						'service': function() { return angular.copy(service); },
						'index': function() { return index; }
					}
				});
				dlg.result.then(function(serviceReturn) {
					$scope.services[serviceReturn.index] = serviceReturn.service;
					Service.save(serviceReturn.service);
				});
			};
			
			$scope.removeService = function(index) {
				Service.delete({id: $scope.services[index].id});
				$scope.services.splice(index,1);
			};
		} ]);

omnibrokerControllers.controller('ServiceEditCtrl', [ '$scope', '$modalInstance', 'service', 'index', function($scope, $modalInstance, service, index) {
	$scope.service = service;
	$scope.index = index;
	
	$scope.ok = function() {
		$modalInstance.close({service: $scope.service, index: $scope.index});
	};
	
	$scope.cancel = function() {
		$modalInstance.dismiss('cancel');
	};
	
	$scope.addPlan = function() {
		service.plans.push({id: generateGUID(), name: "", description: "", metadata: null, free: false});
	};

	$scope.removePlan = function(index) {
		service.plans.splice(index,1);
	};
} ]);

function generateGUID()
{
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
	    var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
	    return v.toString(16);
	}
);
}