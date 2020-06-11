//bootstrapping all the angular controllers and providers
(function () {
    "use strict";
    define([
        'service/esriService',
        'service/mapService',
        'service/layerService',
        'service/queryService',

        'controller/indexCtrl',
        'controller/mapCtrl',
        'controller/toolCtrl'
    ], function (EsriService, MapService, LayerService, QueryService, IndexCtrl, MapCtrl, toolCtrl) {
        
        function init(App) {    
            angular.bootstrap(document.body, ['app']);
            return App;
        }
        return { start: init };
    });
}).call(this);