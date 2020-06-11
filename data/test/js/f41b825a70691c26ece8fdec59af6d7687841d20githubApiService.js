(function (define) {
    "use strict";

    define(["github/github",
            "common/services/notificationService",
            "common/services/loadingIndicatorService",
            "github/services/usersService"
    ],

        function (github) {
            github.factory("githubApiService",
                ["$http", "notificationService", "loadingIndicatorService", "usersService", "$q", "$resource", "$rootScope",
                function service($http, notificationService, loadingService, usersService, $q, $resource, $rootScope) {

                    service.repos = null;
                    var resource = $resource("//api.github.com/users/:user/repos");

                    $rootScope.$on("currentUserDetailsChanged", function () {
                        service.repos = null;
                    });

                    service.initialize = function () {
                        if (service.repos) {
                            return $q.when(service.repos);
                        }
                        loadingService.startLoading();
                        return usersService.initialize()
                            .then(function() {
                                if (usersService.currentUser) {
                                    return resource.query({
                                             user: usersService.currentUser.GithubUserName
                                        })
                                        .$promise
                                        .then(function (repositories) {
                                            service.repos = repositories;
                                            return service.repos;
                                    }, function (error) {
                                            notificationService.error("Error", "Error while loading user repositories.");
                                            throw Error(error);
                                        });
                                } else {
                                    return null;
                                }
                            }, function(error) {
                                notificationService.error("Error", "Error while loading user github details.");
                                throw Error(error);
                            })
                            .finally(function() {
                                loadingService.stopLoading();
                            });
                    }

                    return service;
                }]);
        });

}(window.define));
