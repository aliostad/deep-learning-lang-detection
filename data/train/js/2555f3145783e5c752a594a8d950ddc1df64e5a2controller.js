(function() {
'use strict';

//****************************************
//* <%= controllerName.toUpperCase() %> CONTROLLER
//****************************************

angular.module('<%= appSlug %>')

.config(['$stateProvider', function($stateProvider) {
    $stateProvider
    .state('app.<%= controllerName %>', {
        url: '/<%= controllerName %>',
        controller: '<%= controllerName %>Ctrl as <%= controllerName %>Ctrl',
        templateUrl: '/views/<%= controllerName %>/<%= controllerName %>.tpl',
        resolve: {}
    });
}])

.controller('<%= controllerName %>Ctrl', [
function() {
    console.log('<%= controllerName %>Ctrl loaded');

    var vm = this;
}]);

}());