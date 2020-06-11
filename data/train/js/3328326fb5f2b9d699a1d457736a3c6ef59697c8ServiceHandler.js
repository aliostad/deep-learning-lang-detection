var ServiceHandler = {
    // Get service infos from service config file.
    getServiceInfo : function(serviceName) {
        var serviceInfos = requireHandler.req(
            backendApp.config.serviceRouteFile
        );
        
        if (typeof serviceInfos[serviceName] === 'undefined') {
            throw new Error("'" + serviceName + "' service not exist!");
        } 
        
        return serviceInfos[serviceName];        
    },
    getServiceEntity : function (serviceName) {
        try {
            var servicePath = ServiceHandler.getServiceInfo(serviceName).path;
            return requireHandler.req(servicePath);
        }
        catch (ex) {
            console.log(ex);
            return false;
        }
    }
};

module.exports = {
    getServiceInfo    : ServiceHandler.getServiceInfo,
    getServiceEntity  : ServiceHandler.getServiceEntity
};