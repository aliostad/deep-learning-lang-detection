define(['angular', 'app/AuthenticationController', 'app/RentalHistoryController', 'app/RentalController'],
  function (angular, AuthenticationController, RentalHistoryController, RentalController) {
    var module = angular.module("rylc-controllers", ["rylc-services"]);

    module.controller("rylc.AuthenticationController", AuthenticationController);
    module.controller("rylc.RentalHistoryController", RentalHistoryController);
    module.controller("rylc.RentalController", RentalController);

  });
