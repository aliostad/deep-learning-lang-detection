(function () {
    angular
        .module("StoryGenerator")
        .config(function ($routeProvider) {
            $routeProvider
                .when("/", {
                    templateUrl: "view/main.client.view.html",
                    controller: "MainController",
                    controllerAs: "Model"})
                .when("/result1", {
                    templateUrl: "view/result1.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result2", {
                    templateUrl: "view/result2.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result3", {
                    templateUrl: "view/result3.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result4", {
                    templateUrl: "view/result4.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result5", {
                    templateUrl: "view/result5.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result6", {
                    templateUrl: "view/result6.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result7", {
                    templateUrl: "view/result7.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result8", {
                    templateUrl: "view/result8.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result9", {
                    templateUrl: "view/result9.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result10", {
                    templateUrl: "view/result10.client.view.html",
                    controller: "ResultController",
                    controllerAs: "Model"})
                .when("/result11", {
                        templateUrl: "view/result11.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result12", {
                        templateUrl: "view/result12.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result13", {
                        templateUrl: "view/result13.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result14", {
                        templateUrl: "view/result14.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result15", {
                        templateUrl: "view/result15.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result16", {
                        templateUrl: "view/result16.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result17", {
                        templateUrl: "view/result17.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result18", {
                        templateUrl: "view/result18.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result19", {
                        templateUrl: "view/result19.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"})
                .when("/result20", {
                        templateUrl: "view/result20.client.view.html",
                        controller: "ResultController",
                        controllerAs: "Model"});
            
            
        });
})();