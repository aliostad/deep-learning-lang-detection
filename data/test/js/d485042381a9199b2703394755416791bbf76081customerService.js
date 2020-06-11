var CustomerService;

CustomerService = (function() {
  CustomerService.$inject = ['$http', '$q', 'localStorageService'];

  function CustomerService($http, $q, localStorageService) {
    this.$http = $http;
    this.$q = $q;
    this.localStorageService = localStorageService;
  }

  CustomerService.prototype.getCustomer = function() {
    return this.localStorageService.get('customer');
  };

  CustomerService.prototype.saveCustomer = function(customer) {
    return this.localStorageService.set('customer', customer);
  };

  return CustomerService;

})();

angular.module('app.order.services').service('customerService', CustomerService);
