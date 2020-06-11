var ServiceFactory;
(function (ServiceFactory) {
	
	var pluginName = 'BY.ST.I.Suite.Factory';
	var factoryName = 'ServiceFactory';
	var log = Logger.get(pluginName);
	
	var _module = angular.module(pluginName, []);
	_module.factory(factoryName, [ServiceFactory]);
	

	function ServiceFactory(LoginSevrice) {
		return ConstructService;
		function new ConstructService(){
			this.getService = getService;
			function getService() {
				return LoginSevrice;
			};
		};
};
	
})(ServiceFactory || (ServiceFactory = {}));