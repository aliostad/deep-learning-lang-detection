emmetApp.controller('AppController', ['$scope', 'BackendService', 'DataService', 'TimeService', 'CanvasService', 'ColorService', function ($scope, BackendService, DataService, TimeService, CanvasService, ColorService) 
{
	BackendService.loadData()
		.then(function (data) 
		{
			TimeService.init(1754, 1805); // initialize timeline
			DataService.init(data);
			ColorService.init();
			CanvasService.init(null, null); // initialize dynamic canvas
			d3.select("#loading").remove();
		}, 
		function (error) 
		{
			console.log("error on promise:", error);
		});
	
}]);