describe("Testing", function () {
	beforeEach(module('appstoreApp'));

	var $controller;

	beforeEach(inject(function (_$controller_) {
		$controller = _$controller_;
	}));





	it("Scope Defined", function () {

		var $scope = {};

		var controller = $controller('unitController', {
			$scope: $scope
		});
		expect($scope).toBeDefined();

	});
	it("4 Products", function () {
		var $scope = {};

		var controller = $controller('unitController', { 
			$scope: $scope
		});
		expect($scope.productList.product1.name).toEqual("Product1");
	});
});