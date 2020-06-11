/******************************************************************************  
*   CONTROLLER/INDEX.JS
*   Description: Defines a single angular controller
*   Use: Registers controller with controller module and injects to core module
*    
*******************************************************************************/

;(function () {
    "use strict";

    angular.module("maps")

        .controller("RootController", require("./root-controller.js"))
        .controller("LandingController", require("./landing-controller.js"))
        .controller("ServicesController", require("./services-controller.js"))
        .controller("CategoriesController", require("./categories-controller.js"))
        .controller("SearchController", require("./search-controller.js"))
        .controller("LocationController", require("./location-controller.js"))
        .controller("LocalSearchController", require("./local-search-controller.js"))
        .controller("LocalFoundController", require("./local-found-controller.js"))
        .controller("StreetworksSearchController", require("./streetworks-search-controller.js"))
        .controller("typeahead", require("./typeahead-controller.js"));
}());
