/**
 * Additional header nav
 */
var HeaderNavDirective = function HeaderNavDirective() {
    return {
        restrict: 'E',
        template: '<nav class="ui-header-nav navbar navbar-default"><ul class="nav navbar-nav" data-ng-transclude=""></ul></nav>',
        replace: true,
        transclude: true,
        scope: {},
        link: function (scope, element, attrs) {

        }
    };
};

// Set up dependency injection
HeaderNavDirective.$inject = [];

// Register directive into AngularJS
angular
    .module('Layout')
    .directive('uiHeaderNav', HeaderNavDirective);