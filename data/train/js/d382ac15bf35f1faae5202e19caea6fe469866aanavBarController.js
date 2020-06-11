(function() {

    var NavBarController = function($scope, jimhubFactory, $routeParams) {

        $scope.navBarItems = [];

        $scope.showNavBarSelector = false;

        $scope.navBarSelectorPos = 0;
        $scope.navBarItemWidth = 0;

        $scope.slideMeNow = false;

        function init() {
            jimhubFactory.getNavBarItems()
                .success(function(navBarItems) {

                    var itemWidth = 800 / navBarItems.length;

                    for(var i=0; i < navBarItems.length; i++) {
                        if(navBarItems[i].link[0] != '#') {
                            navBarItems[i].target = "_blank";
                        }

                        navBarItems[i].xPos = itemWidth * i;
                    }

                    $scope.navBarItems = navBarItems;

                    $scope.navBarItemWidth = itemWidth;
                })
                .error(function(data, status, headers, config) {
                    console.error("No get navBarItems :( "+data+" "+status);
                });
        }

        $scope.selectCat = function(pos) {
            $scope.showNavBarSelector = true;
            $scope.navBarSelectorPos = pos;
            $scope.slideMeNow = true;
            
            console.log($routeParams);
        }

        init();

    };

    // Parameter injection to avoid trouble from minification
    NavBarController.$inject = ['$scope', 'jimhubFactory', '$routeParams'];

    angular.module('jimhubApp')
        .controller('NavBarController', NavBarController);

}());
