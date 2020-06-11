angular.module('JFC.controller', [])
    .constant('progressConfig', {
        urlPrefix : (function(){
            return (location.port === '84') ? location.protocol + '//' + location.hostname + ':8080' : '';
        })()
    })
    .controller("ApplicationController", ["$scope", "$http", "$location", "$timeout", "$rootScope","$localStorage","$sessionStorage", "progressConfig", ApplicationController])
    .controller("HomeController", ["$scope", "$route","$http","$routeParams", "progressConfig", HomeController])
    .controller("ConfigController", ["$scope", "$route","$http","$localStorage", "$routeParams", "progressConfig", ConfigController])    
    .controller("AdminController", ["$scope", "$route","$http","$timeout", "$location", "$routeParams", "progressConfig", AdminController])
    .controller("SceneController", ["$scope", "$route","$http","$localStorage", SceneController])
    .controller("LoginController", ["$scope", "$route","$http","$localStorage", LoginController])
    .controller("UISelectController", ["$scope", "$attrs", "progressConfig", UISelectController])
    .controller("UISearchController", ["$scope", "$attrs", "progressConfig", UISearchController])
    .controller("UITextController", ["$scope", "$attrs", "progressConfig", UITextController])
    .controller("UITextAreaController", ["$scope", "$attrs", "progressConfig", UITextAreaController])
    .controller("UIChartItemController", ["$scope", "$attrs", "progressConfig", "$timeout", UIChartItemController])
    .controller("UIChartOptionController", ["$scope", "$attrs", "progressConfig", "$timeout", "$filter", UIChartOptionController])
    .controller("UIAnchoredModalController", ["$scope", "$attrs", "progressConfig", "$timeout", UIAnchoredModalController]);
