ndexApp.controller('apiController',
    [ 'ndexService', 'sharedProperties', '$scope', '$location', '$modal',
        function (ndexService, sharedProperties, $scope, $location, $modal) {
            $scope.api = {};
            var api = $scope.api;

            //Network
            api.network = false;
            api.networkApiError = false;
            api.getNetworkApi = function()
            {
                ndexService.getNetworkApi(
                    function(methods)
                    {
                        api.network = methods;
                    },
                    function(error, data)
                    {
                        api.networkApiError = "Error while retrieving Network API";
                    })
            };
            api.getNetworkApi();

            //User
            api.user = false;
            api.userApiError = false;
            api.getUserApi = function()
            {
                ndexService.getUserApi(
                    function(methods)
                    {
                        api.user = methods;
                    },
                    function(error, data)
                    {
                        api.userApiError = "Error while retrieving User API";
                    })
            };
            api.getUserApi();

            //Group
            api.group = false;
            api.groupApiError = false;
            api.getGroupApi = function()
            {
                ndexService.getGroupApi(
                    function(methods)
                    {
                        api.group = methods;
                    },
                    function(error, data)
                    {
                        api.userGroupError = "Error while retrieving User API";
                    })
            }
            api.getGroupApi();

            //Request
            api.request = false;
            api.requestApiError = false;
            api.getRequestApi = function()
            {
                ndexService.getRequestApi(
                    function(methods)
                    {
                        api.request = methods;
                    },
                    function(error, data)
                    {
                        api.requestApiError = "Error while retrieving User API";
                    })
            }
            api.getRequestApi();

            //Task
            api.task = false;
            api.taskApiError = false;
            api.getTaskApi = function()
            {
                ndexService.getTaskApi(
                    function(methods)
                    {
                        api.task = methods;
                    },
                    function(error, data)
                    {
                        api.taskApiError = "Error while retrieving User API";
                    })
            }
            api.getTaskApi();

        }
    ]);

