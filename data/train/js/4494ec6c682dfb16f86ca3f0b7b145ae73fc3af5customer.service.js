(function () {
"use strict";

angular.module('common')
.service('CustomerService', CustomerService);

function CustomerService() {
  var service = this;

  service.get = function () {
    return service.customer;
  };

  service.has = function () {
    return service.customer != null;
  };

  service.save = function (customer) {
    service.customer = customer;
  };

  service.reset = function () {
    service.customer = null;
  };

  service.reset();

  // service.save({
  //   firstName: 'First',
  //   lastName: 'Last',
  //   email: 'Email',
  //   phone: 'Phone',
  //   favoriteMenuNumber: 'A1'
  // });
}
})();
