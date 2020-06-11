define(['angular' , 'app/AuthenticationController', 'app/CommunicationController' //, 'app/RentalHistoryController', 'app/ConversationController', 'app/RentalController'
        ],
  function (angular, AuthenticationController, CommunicationController //, RentalHistoryController, ConversationController, RentalController
		  ) {
    var module = angular.module("entarena-controllers", ["entarena-services"]);

    module.controller("entarena.AuthenticationController", AuthenticationController);
    module.controller("entarena.CommunicationController", CommunicationController);
       
//    module.controller("rylc.RentalHistoryController", RentalHistoryController);
//    module.controller("rylc.ConversationController", ConversationController);
//    module.controller("rylc.RentalController", RentalController);

  });
