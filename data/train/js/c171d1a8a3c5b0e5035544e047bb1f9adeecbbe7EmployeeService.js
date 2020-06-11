// servicename, return function



cmApp.factory('EmployeeService', function (cmApi) {

    var ApiEndpointName = "Employee";
    return {
        

        Get: function (data) {
            return cmApi.get(ApiEndpointName+"/"+data);
        },

        Create: function (data) {
            return cmApi.post(ApiEndpointName, data);
        },

        Update: function (data) {
            return cmApi.put(ApiEndpointName, data);
        },

        Delete: function (data) {
            return cmApi.delete(ApiEndpointName, data);
        },


    }

});


