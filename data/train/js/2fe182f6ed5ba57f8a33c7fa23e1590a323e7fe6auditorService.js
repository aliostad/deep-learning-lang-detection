coreServicesModule.service('auditorService', function ($window, $q, $http, loggingService, serviceClientService) {
    "use strict";

    var isDebug = false;
    this.serviceName = "auditorService";
    this.endPointPath = "/auditorEndpoint/v1";

    this.search = function(auditorSearchCriteria){
        return serviceClientService.put(isDebug, this.serviceName, this.endPointPath + "/search", auditorSearchCriteria);
    }
    
    this.getAgencyList = function(){
    	return serviceClientService.get(isDebug, this.serviceName, this.endPointPath + "/getAgencyList"); 
    }

});
