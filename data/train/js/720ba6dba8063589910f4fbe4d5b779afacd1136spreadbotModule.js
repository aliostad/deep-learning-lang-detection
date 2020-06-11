define([
    'angular',
    './spreadBotDirective',
    './assessmentDirective',
    './spreadBotService',
    './assessmentService'
], function (angular, spreadBotDirective, assessmentDirective, spreadBotService, assessmentService) {
    'use strict';

    angular.module('spreadBotModule', [])
        .service('spreadBotService', spreadBotService)
        .service('assessmentService', assessmentService)
        .directive('spreadBot', spreadBotDirective)
        .directive('assessment', assessmentDirective);
});