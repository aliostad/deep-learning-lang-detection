angular.module('ngAlone.events')
    .factory('EventEffects', ['ResourceService', function(ResourceService){
        'use strict';
        return {
            lockEvent: function(variables, eventsService){
                eventsService.lockEvent(variables.lock);
            },
            unlockEvent: function(variables, eventsService){
                eventsService.unlockEvent(variables.unlock);
            },
            unlockCategory: function(variables, eventsService){
                eventsService.unlockCategory(variables.unlockCategory);
            },
            unlockAction: function(variables, eventsService){
                ResourceService.unlockResourceAction(variables.unlockAction);
            },
            unlockResource: function(variables, eventsService){
                ResourceService.unlockResource(variables.unlockResource);
            }
        };
    }]);



