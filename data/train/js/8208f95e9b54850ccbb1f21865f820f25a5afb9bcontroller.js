// Laserfiche  - Copyright(c) 1993-2013 Compulink Management Center, Inc.

/**
 * @name controller
 * @requires 
 *           controller.mainctrl - the main controller for the application.
 * @description
 * Application controllers.
 **/
angular.module('controller', ['controller.main',
                              'controller.account',
                              'controller.grid',
                              'controller.user',
                              'controller.record',
                              'controller.card',
                              'controller.chart'
]);
