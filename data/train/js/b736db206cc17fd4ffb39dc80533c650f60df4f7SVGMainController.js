define([
    "jquery",
    "underscore",
    "backbone",
    "demos/rube/controllers/LoadRubeController",
    "demos/svg/controllers/SVGDemoViewController"
    ], function($, _, Backbone, LoadRubeController, SVGDemoViewController ) {
    

    function SVGMainController( model ) {

        var loadRubeController = new LoadRubeController();
        var demoViewController = new SVGDemoViewController();
        
        // loader needs the world reference that the controller creates
        demoViewController.init(loadRubeController);
        
    }

    return SVGMainController;

});