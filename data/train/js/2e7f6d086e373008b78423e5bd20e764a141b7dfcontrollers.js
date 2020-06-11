define(['angular',
    'jquery',
    'appController',
    'homeController',
    'listController',
    'storyController',
    'moodVoteController'],
    function (angular,
              $,
              appController,
              homeController,
              listController,
              storyController,
              moodVoteController)
    {
        // Force strict coding
        'use strict';

        return angular.module('myApp.controllers', ['myApp.controllers.appController',
                                                    'myApp.controllers.homeController',
                                                    'myApp.controllers.listController',
                                                    'myApp.controllers.storyController',
                                                    'myApp.controllers.moodVoteController'])


    });