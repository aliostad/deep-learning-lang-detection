var config = require("../config")();
var factory = function(providerType, serviceName) {
    var service = null;
    switch (providerType) {
        case "mongo":
            service = require([".", "mongo", serviceName + "Service"].join("/"))();
            break;
        case "remote":
            service = require([".", "remote", serviceName + "Service"].join("/"))();
            break;
        default:
            service = require([".", providerType, serviceName + "Service"].join("/"))();
            break;

    }
    return service;
};
module.exports = {
    /**
     * instance specificed data provider type, such xml, mongo
     * @param  {string} providerType e.g. xml, mongo, mysql
     * @param  {string} serviceName  the service name, e.g.  product, user
     * @return {[type]}              [description]
     */
    get: function(providerType, serviceName) {
        if (arguments.length == 1) {
            serviceName = providerType;
            providerType = config.defaultDataProvider;
        }
        return factory(providerType, serviceName);
    }
}
