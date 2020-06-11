var Router = {
    getServiceInC9 : function(url) {
        var service = url.slice(backendApp.config.baseRouteUrl.length);
        // Service is only the first word after baseRouteUrl.
        
        var serviceName   = service.slice(0, service.indexOf("/"));
        var serviceAction = service.slice(serviceName.length + 1, service.length);

        return {
            name   : serviceName,
            action : serviceAction
        };
    },
    getServiceInLocalhost   : function (url) {
        var service = url.slice(1);
        var serviceName   = service.slice(0, service.indexOf("/"));
        var serviceAction = service.slice(serviceName.length + 1, service.length);

        return {
            name   : serviceName,
            action : serviceAction
        };
    }
};

module.exports =  {
    getService : Router.getServiceInLocalhost
};