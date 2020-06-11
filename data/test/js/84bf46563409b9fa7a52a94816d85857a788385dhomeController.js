'use strict';
app.controller('homeController', ['$scope', 'tvShowService', function ($scope, tvShowService) {

    $scope.allShows = [];

    tvShowService.getShows().then(function success(results) {
        $scope.allShows = results.data.map(function (show) {
            show.hover = false;
            return show;
        });
    });

    $scope.hoverIn = function () {
        this.show.hover = true;
    };

    $scope.hoverOut = function () {
        this.show.hover = false;
    };

    $scope.heartIt = function () {
        if (!this.show.favorite) {
            tvShowService.addFavorite(this.show);
            this.show.favorite = true;
        } else {
            console.log("remove");
        }
    };
}]);