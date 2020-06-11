/*global define */

define(function(require) {

    'use strict';

    var angular = require('angular'),
        config = require('config'),
        services = angular.module('app.services', ['app.config']);

    services.factory('UserService', require('services/UserService'));
    services.factory('RoomService', require('services/RoomService'));
    services.factory('SearchService', require('services/SearchService'));
    services.factory('PlayersService', require('services/PlayersService'));
    services.factory('AdminService', require('services/AdminService'));

    return services;

});
