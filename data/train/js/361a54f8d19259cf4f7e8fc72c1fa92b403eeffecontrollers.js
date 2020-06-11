define(['angular', 'app/AuthenticationController', 'app/RentalHistoryController', 'app/ConversationController', 'app/RentalController'],
  function (angular, AuthenticationController, RentalHistoryController, ConversationController, RentalController) {
    var module = angular.module("rylc-controllers", ["rylc-services"]);

    module.controller("rylc.AuthenticationController", AuthenticationController);
    module.controller("rylc.RentalHistoryController", RentalHistoryController);
    module.controller("rylc.ConversationController", ConversationController);
    module.controller("rylc.RentalController", RentalController);

  });
