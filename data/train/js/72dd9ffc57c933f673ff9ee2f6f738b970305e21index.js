(function (controllers) {

  var homeController = require("./homeController");
  var notesController = require("./notesController");
  var cabController=require("./cabController");
  var driverController=require("./driverController");
  var tripController=require("./tripController");
  var affiliateController=require("./affiliateController");
  var callRedirectController=require("./callRedirectController");
  var PassengerDetailController=require("./passengerDetailController");
  
  controllers.init = function (app) {

    homeController.init(app);
    notesController.init(app);
    cabController.init(app);
    driverController.init(app);
    tripController.init(app);
    affiliateController.init(app);
    callRedirectController.init(app);
    PassengerDetailController.init(app);

  };
})(module.exports);