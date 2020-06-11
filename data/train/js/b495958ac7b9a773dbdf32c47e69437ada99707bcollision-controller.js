collision.controller('collisionController', ['$scope', 'collisionService', 'enumsService',
	function ($scope, collisionService, enumsService) {
		collisionService.activate();

		$scope.friction = collisionService.getFriction();
		$scope.gravity = collisionService.getGravity();
		$scope.charge = collisionService.getCharge();
		$scope.onFrictionChange = collisionService.onFrictionChange;
		$scope.onGravityChange = collisionService.onGravityChange;
		$scope.onChargeChange = collisionService.onChargeChange;

		$scope.enums = enumsService;
		$scope.forceLife = collisionService.getForceLife();

		$scope.onForceLifeChange = collisionService.onForceLifeChange;
		$scope.startForce = collisionService.startForce;
		$scope.stopForce = collisionService.stopForce;

		$scope.$on('$destroy', onDestroy);

		function onDestroy() {
			collisionService.deactivate();
		}
	}]);