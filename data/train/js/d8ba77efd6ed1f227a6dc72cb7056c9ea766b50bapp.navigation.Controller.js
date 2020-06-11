app.controller('AppNavigationController',
    ['$scope', '$routeParams', '$location', '$rootScope',
        function ($scope, $routeParams, $location, $rootScope) {
            /** testing start */

            $scope.toggleContentNavCard = function () {
                if($scope.ContentNavCard == true){
                    $scope.ContentNavCard = false;
                    $scope.deactivateNavigation();
                } else {
                    $scope.ContentNavCard = true;
                    $scope.activateNavigation();
                }
            };

            $scope.toggleTaxonomyNavCard = function () {
                if($scope.TaxonomyNavCard == true){
                    $scope.TaxonomyNavCard = false;
                    $scope.deactivateNavigation();
                } else {
                    $scope.TaxonomyNavCard = true;
                    $scope.activateNavigation();
                }
            };

            $scope.toggleFormulaNavCard = function () {
                if($scope.FormulaNavCard == true){
                    $scope.FormulaNavCard = false;
                    $scope.deactivateNavigation();
                } else {
                    $scope.FormulaNavCard = true;
                    $scope.activateNavigation();
                }
            };

            $scope.toggleNameNavCard = function () {
                if($scope.NameNavCard == true){
                    $scope.NameNavCard = false;
                    $scope.deactivateNavigation();
                } else {
                    $scope.NameNavCard = true;
                    $scope.activateNavigation();
                }
            };

            $scope.toggleDatabaseNavCard = function () {
                if($scope.DatabaseNavCard == true){
                    $scope.DatabaseNavCard = false;
                    $scope.deactivateNavigation();
                } else {
                    $scope.DatabaseNavCard = true;
                    $scope.activateNavigation();
                }
            };

            $scope.toggleAllNavCards = function () {
                $scope.toggleContentNavCard();
                $scope.toggleTaxonomyNavCard();
                $scope.toggleFormulaNavCard();
                $scope.toggleNameNavCard();
            };

            $rootScope.closeAllNavCards = function () {
                $scope.FormulaNavCard = false;
                $scope.TaxonomyNavCard = false;
                $scope.ContentNavCard = false;
                $scope.NameNavCard = false;
                $scope.DatabaseNavCard = false;
                $rootScope.navOn = false;
            };

            /**
             * This is for showing the navigation overlay
             */
            $scope.activateNavigation = function () {
                $rootScope.navOn = true;
            };

            /**
             * This is for hiding the navigation overlay if all the menus are closed
             */
            $scope.deactivateNavigation = function () {
                if(
                    ($scope.ContentNavCard == false || typeof $scope.ContentNavCard == "undefined") &&
                    ($scope.TaxonomyNavCard == false || typeof $scope.TaxonomyNavCard == "undefined") &&
                    ($scope.FormulaNavCard == false || typeof $scope.FormulaNavCard == "undefined") &&
                    ($scope.NameNavCard == false || typeof $scope.NameNavCard == "undefined") &&
                    ($scope.DatabaseNavCard == false || typeof $scope.DatabaseNavCard == "undefined")
                ){
                    $rootScope.navOn = false;
                }
            };

            $scope.testDirective = function () {
                console.log("test");
            };

        }]);
