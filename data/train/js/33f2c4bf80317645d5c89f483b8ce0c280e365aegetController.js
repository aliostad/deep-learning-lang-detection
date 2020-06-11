var Controller =            require("../controllers/Controller.js");
var EventController =       require("../controllers/EventController.js");
var TimelineController =    require("../controllers/TimelineController.js");
var PlotPointController =   require("../controllers/PlotPointController.js");
var PersonController =      require("../controllers/PersonController.js");
var PlotController =        require("../controllers/PlotController.js");
var url = require("url");

module.exports = function getController(serverRequest){
    
    var pathParts = url.parse(serverRequest.url).pathname.split("/");
    var controller = Controller;
    switch (pathParts[1]) {
        case "event":
            controller = EventController;
            break;
        case "timeline":
            controller = TimelineController;
            break;
        case "plotPoint":
            controller = PlotPointController;
            break;
        case "person":
            controller = PersonController;
            break;
        case "plot":
            controller = PlotController;
            break;
    }
    
    return new controller(serverRequest);
    
};