packager('academy.controllers', function() {
	academy.app.controller("MiddleController", ["UserService", "UserDataService", "PassportService", "ProductService", "HistoryService", "ViewService", function(UserService, UserDataService, PassportService, ProductService, HistoryService, ViewService) {

		var vm = this;

		vm.userService = UserService;
		vm.userDataService = UserDataService;
		vm.passportService = PassportService;
		vm.productService = ProductService;
		vm.historyService = HistoryService;
		vm.viewService = ViewService;
	}]);
});