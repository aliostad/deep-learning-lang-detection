(function() {
    
    var ActorsController = function ($scope, $routeParams, showsFactory) {
        var showId = $routeParams.showId;
        $scope.show = null;
        
        function init() {
             showsFactory.getShow(showId)
                .success(function(show) {
                    $scope.show = show;
                })
                .error(function(data, status, headers, config) {
                    //handle error
                });
        }        

        init();
    };
    
    ActorsController.$inject = ['$scope', '$routeParams', 'showsFactory'];

    angular.module('showsApp')
      .controller('ActorsController', ActorsController);
    
}());