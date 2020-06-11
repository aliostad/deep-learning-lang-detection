define(['controllers/orgProdHierarchyController', 'controllers/navigationController'],
	function(OrgProdHierarchyController, NavigationController) {
		var MainController; 
		return MainController = (function(){
			
			MainController.prototype.initialize = function() {
				this.initSidebar();
				return this.initNav();
			};
			
			MainController.prototype.initSidebar = function() {
				var sidebarController = new OrgProdHierarchyController();
				sidebarController.initialize();
			};
			
			MainController.prototype.initNav = function() {
				var navController = new NavigationController();
				navController.initialize();
			};
		});
	}
);
