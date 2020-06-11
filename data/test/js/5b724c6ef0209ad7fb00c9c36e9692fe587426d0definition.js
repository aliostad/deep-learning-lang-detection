define(['angular'], function (angular) {
    'use strict';

    angular.module('DefinitionCtrl', [])
        .controller('DefinitionController', ["CheckingService", "TasksContentService", "DeviceService", "MediaService", "AnimationService",
            function (CheckingService, TasksContentService, DeviceService, MediaService, AnimationService) {

            this.tasksContent = TasksContentService;
            this.checking = CheckingService;
            this.device = DeviceService;
            this.media = MediaService;
            this.animation = AnimationService;

            this.animation.resetAnimation();

        }]);
});