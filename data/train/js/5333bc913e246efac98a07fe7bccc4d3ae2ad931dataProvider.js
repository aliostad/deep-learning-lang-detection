'use strict';

define(function(require) {
        var angular = require('angular');
        var models = require('teacher/models');
        var userModels = require('users/models');
        var GameService = require('./GameService');
        var InteractionService = require('./InteractionService');
        var ObjectiveService = require('./ObjectiveService');
        var TagService = require('./TagService');
        var NoteService = require('./NoteService');
        var UserService = require('./UserService');

        var moduleName = 'kasparGUI.teacher.dataProvider';
        var dependancies = [
            models,
            userModels,
        ];

        var module = angular.module(moduleName, dependancies)
            .service('gameService', GameService)
            .service('interactionService', InteractionService)
            .service('objectiveService', ObjectiveService)
            .service('tagService', TagService)
            .service('noteService', NoteService)
            .service('userService', UserService);

        return moduleName;
    });