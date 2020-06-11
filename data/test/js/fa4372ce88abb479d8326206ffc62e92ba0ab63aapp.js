/* Configuration of angular, creation of controller, service...  */

var app = angular.module('search-module',['ngRoute','angular-ace-editor','ui.grid','ui.bootstrap', 'ui.grid.autoResize'
                                          , 'ui.grid.edit', 'ui.grid.cellNav', 'ui.grid.expandable','ui.grid.resizeColumns']);

app
    .service('SearchServ',SearchService)
    .service('HostServ',HostService)
    .service('BatchServ',BatchService)
    .service('OrganizationServ',OrganizationService)

    .controller('HomeController',HomeController)
    .controller('SearchController',SearchController)
    .controller('ResultsController',ResultsController)
    .controller('OrganizationController',OrganizationController)
    .controller('ReferentielController',ReferentielController)
    .controller('OtherDataController',OtherDataController)
    .controller('BatchController',BatchController)
    .controller('ModalInstanceCtrl',ModalInstanceCtrl)

    .config(function($routeProvider){
        configRoute($routeProvider);
    })
