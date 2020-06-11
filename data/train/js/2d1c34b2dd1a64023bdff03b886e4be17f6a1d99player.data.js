'use strict';
/**
 * Created by Dustin on 4/4/2015.
 */
/**
 * Player data model, this will be rafactored to talk to the db eventually
 */
angular.module( 'playerMod' ).factory( 'playerData', function () {

    //Get a new instance
    return function () {

        var service = {};

        //Default player data
        service.inventory =     [];
        service.events =        [];
        service.weapon =        0;
        service.armor =         0;
        service.shield =        0;
        service.hp =            10;
        service.attack =        1;
        service.defense =       1;
        service.experience =    0;
        service.next =          10;

        return service;

    }

});