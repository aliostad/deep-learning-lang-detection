(function(){
    'use strict';
    function controller($scope, updateService, modalService, ownerService){
        var self = this;
        this.$scope = $scope;
        this.updateService = updateService;
        this.modalService = modalService;
        this.ownerService = ownerService;
        this.init = function(){
        	this.super('init'); 	
        	this.$scope.ownerListData = this.ownerService.model;
        	this.ownerService.get();
        }
        this.init();
    }
    controller.prototype = baseController;

    controller.$inject = ['$scope', 'company.service', 'modalService', 'owner.service'];
    MetronicApp.controller('company.mainController', controller);
}());