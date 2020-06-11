define([
    'angular',
    'topic/ModalService',
    'topic/LoadDirective',
    'topic/ParentScrollDirective',
    'topic/TopicController',
    'topic/EditController'
], function (
    angular,
    ModalService,
    LoadDirective,
    ParentScrollDirective,
    TopicController,
    EditController
) {
    angular.module('cmtyTopic', [])

    .factory('ModalService', ModalService)
    .directive('cmtyLoad', LoadDirective)
    .directive('cmtyParentScroll', ParentScrollDirective)
    .controller('TopicController', TopicController)
    .controller('EditController', EditController);
});
