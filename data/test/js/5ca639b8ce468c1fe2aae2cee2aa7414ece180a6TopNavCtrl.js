angular.module('TopNav', ['CurrentState'])
	.controller('TopNavCtrl', function($scope, $state, $http, CurrentState) {
		$scope.data = {};
		window.scope = $scope;

		this.getServiceProviderSelected = function() {
			var d = CurrentState.getServiceProviderSelected();
			return (d.serviceProviderName) ? d.serviceProviderName : '';
		};

		CurrentState.getServiceProviders(function(serviceProviders) {
			$scope.data.serviceProviders = serviceProviders;
			$scope.data.serviceProvider = CurrentState.getServiceProviderSelected().serviceProvider;
		});

		$scope.selectServiceProvider = function() {
			$http.get('/service-provider/select/' + $scope.data.serviceProvider)
				.success(function(data) {
					CurrentState.set('serviceProvider', data.serviceProvider);
					CurrentState.set('serviceProviderName', data.serviceProviderName);
				});
		};

		$scope.getName = function() {
			return CurrentState.getName();
		}
	})