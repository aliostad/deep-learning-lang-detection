// ---------------------------------------------------------------------------------------------------------------------
// A service for retrieving/working with wiki configs.
//
// @module config.js
// ---------------------------------------------------------------------------------------------------------------------

function ConfigServiceFactory($resource)
{
    var Config = $resource('/config');

    function ConfigService()
    {
        this.config = Config.get();
    } // end ConfigService

    ConfigService.prototype.refresh = function()
    {
        this.config = Config.get();
    }; // end refresh

    return new ConfigService();
} // end ConfigServiceFactory

// ---------------------------------------------------------------------------------------------------------------------

angular.module('tome.services').service('ConfigService', [
    '$resource',
    ConfigServiceFactory
]);

// ---------------------------------------------------------------------------------------------------------------------