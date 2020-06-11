; (function (angular) {
    'use strict';

    angular.module('app').service('templateService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('Template', true);
    }]);

    angular.module('app').service('newsService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('News', true);
    }]);

    angular.module('app').service('onlineRadioService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('OnlineRadio', true);
    }]);

    angular.module('app').service('navigationService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('Navigation', true);
    }]);

    angular.module('app').service('loggingService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('Logging');
    }]);

    angular.module('app').service('userService', ['apiFactory', function (apiFactory) {
        return apiFactory.create('User');
    }]);

})(angular);