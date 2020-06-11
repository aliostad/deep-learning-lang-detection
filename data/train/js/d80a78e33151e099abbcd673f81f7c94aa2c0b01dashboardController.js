'use strict';
app.controller('DashboardCtrl', ['$scope', '$location', 'authService', 'statisticService', 'timelineService', 'alertService', '$rootScope',
    function ($scope, $location, authService, statisticService, timelineService, alertService, $rootScope) {
        statisticService.getUserStatistics().then(function (data) {
            $scope.UserStatistics = data;
        });

        //Fetch timeline
        timelineService.getUserTimeline(5).then(function (data) {
            $scope.Timeline = data;
        });
}]);