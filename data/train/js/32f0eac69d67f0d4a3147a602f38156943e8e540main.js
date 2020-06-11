'use strict';

tapiiriControllers.controller('MainController', function ($scope) {

});

tapiiriControllers.controller('HeaderController', function ($scope, $location) {
  $scope.isActive = function (viewLocation) {
    return viewLocation === $location.path();
  };
});

tapiiriControllers.controller('E-sportsController', function ($scope) {

});

tapiiriControllers.controller('SoftwareController', function ($scope) {

});

tapiiriControllers.controller('BroadcastingController', function ($scope) {

});

tapiiriControllers.controller('EventsController', function ($scope) {

});
