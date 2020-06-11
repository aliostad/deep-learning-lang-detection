(function () {
    "use strict";

    function userStoriesService() {
        var service = CoreServices.userStoryServiceInstance;
        var baseService = new ServiceParts.BaseCrudService(service);

        this.create = function(story, callback) {
            baseService.create(story, callback);
        }

        this.modify = function (story) {
            baseService.modify(story);
        }

        this.deleteEntity = function(story) {
            baseService.deleteEntity(story);
        }
    }

    angular
        .module("app")
        .service("userStoriesService", userStoriesService);

    //userStoriesService.$inject = ['$http'];
})();