(function(){
	'use strict';
	function controller($scope, updateService, modalService, vehicleService, vendorService){
		this.$scope = $scope;
		this.updateService = updateService;
		this.modalService = modalService;
		this.init = function(){
        	this.super('init');
        	vehicleService.get();
            vendorService.get();
        	this.$scope.vehicle = vehicleService.model;
        	this.$scope.dealer = vendorService.model;
        }

        this.init();
	}
	controller.prototype = baseController;

	controller.$inject = ['$scope', 'fuelEntrie.service', 'modalService', 'vehicle.service','vendor.service'];
	MetronicApp.controller('fuelEntrie.mainController', controller);
}());