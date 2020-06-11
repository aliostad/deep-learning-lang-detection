/**
 * @author shirakg
 */
//var sf = angular.module('serviceFactory', []);
EmployeeDirectory.service('EmployeeModel',function(){
	var EmployeeService = new EmployeeServiceProxy;
	return EmployeeService;
});
/*

EmployeeDirectory.service('DepartmentModel',function(){
	var DepartmentService = new DepartmentServiceProxy;
	return DepartmentService;
});
*/

/*sf.factory('EmployeeService', function(){
	var EmployeeService = new EmployeeServiceProxy;
	return EmployeeService;
})

sf.factory('SharedService', function($rootScope){
	var sharedService = {};
	sharedService.message = '';
	sharedService.prepForBroadcast = function(msg){
		this.message = msg;
		this.broadcastItem();
	};
	
	sharedService.broadcastItem = function(){
		$rootScope.$broadcast('handleBroadcast');
	};
})
*/