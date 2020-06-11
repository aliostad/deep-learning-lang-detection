(function(){
  'use strict';

  angular.module('ServiceApp',[])
  .controller('ServiceTaxController',ServiceTaxController)
  .service('ServiceTaxCalculationService',ServiceTaxCalculationService);
  // regiter the service to the angular module

  ServiceTaxController.$inject = ['ServiceTaxCalculationService'];
  // inject the service

  // define the conroller
  function  ServiceTaxController(ServiceTaxCalculationService){
    var controller = this;
    controller.amount = "";
    controller.tax ="";

    controller.calculateTax = function(){
      // delegate the business logic to the Service
      controller.tax = ServiceTaxCalculationService.calculateTax(controller.amount);
    }
  }

  // Service definition function
  function ServiceTaxCalculationService(){
    var service = this;

    service.calculateTax = function(chargeAmount){
      return 0.05 * chargeAmount;
    }
  }

})();
