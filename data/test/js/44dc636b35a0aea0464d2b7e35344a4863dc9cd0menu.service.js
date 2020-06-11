(function () {
	"use strict";

	angular.module('common')
	.service('MenuService', MenuService);


	MenuService.$inject = ['$http', 'ApiPath'];
	function MenuService($http, ApiPath) {
		var service = this;
		var items=[];
		service.firstName="";
		service.lastName="";
		service.email="";
		service.phoneNumber="";
		service.itemName="";
		service.itemDesc="";
		service.shortName="";
service.saved=false;
		service.getCategories = function () {
			return $http.get(ApiPath + '/categories.json').then(function (response) {
				return response.data;
			});
		};


		service.getMenuItems = function (category) {
			var config = {};
			if (category) {
				config.params = {'category': category};
			}

			return $http.get(ApiPath + '/menu_items.json', config).then(function (response) {
				return response.data;
			});
		};

		service.saveFromSubmit=function(userShortName){
			return $http({method: "GET",url: (ApiPath + "/menu_items/"+userShortName+".json")}).then(function (response) {
	return response;
			});


		};

service.saveInService=function(user){
	service.firstName=user.firstName;
	service.lastName=user.lastName;
	service.email=user.email;
	service.phoneNumber=user.phone;
	service.itemName=user.item.name;
	service.itemDesc=user.item.description;
	service.shortName=user.shortName;
	service.saved=user.saved;
}

service.resetInService=function(){
	service.firstName="";
	service.lastName="";
	service.email="";
	service.phoneNumber="";
	service.itemName="";
	service.itemDesc="";
	service.shortName="";
	service.saved="";
}
service.getFromService=function(){
	var user= {
					     firstName:service.firstName,
					     lastName:service.lastName,
					     email:service.email,
					     phone:service.phoneNumber,
					     itemName:service.itemName,
							 itemDesc:service.itemDesc,
							 itemImage:ApiPath+"/images/"+service.shortName+".jpg",
							 itemSaved:service.saved
					   };
return user;
}
	}



})();
