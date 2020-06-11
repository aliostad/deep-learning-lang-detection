wreportApp.factory("wreportCommService", function(){

    var _employees = [];
    var _retailers = [];
    var _user;

    var service = {};
    service.set_employee = function(employees){
	_employees = employees;
    };
    service.get_employee = function(){
	return _employees;
    };

    service.set_retailer = function(retailers){
	service._retailers =retailers;
    };
    service.get_retailer = function(){
	return service._retailers;
    };

    service.set_user = function(user){
	service._user = user;
    };
    service.get_user = function(){
	return service._user;
    };
    
    service.get_shop_id = function(){
	// console.log(service._user);
	return service._user.shopIds.length === 0
	    ? undefined:service._user.shopIds;
    };
    service.get_sort_shop = function(){
	return service._user.sortShops;
    };

    return service;
});
