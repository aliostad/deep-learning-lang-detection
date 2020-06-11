/**
 * Created by Amit Thakkar on 10/16/15.
 */
((ng) => {
    "use strict";
    let dynamicMongooseSchemaModule = ng.module('dynamicMongooseSchema');
    dynamicMongooseSchemaModule.controller('ApiEditController', [
        'ApiService', '$routeParams',
        function (ApiService, $routeParams) {
            let apiEdit = this;
            apiEdit.activate = ['$scope', function ($scope) {
                $scope.setTitleAndPageProperty('API Edit', 'api-edit');
            }];
            apiEdit.methods = [
                'GET',
                'POST',
                'PUT',
                'DELETE'
            ];
            ApiService.get($routeParams._id)
                .success((updatedApi) => {
                    apiEdit.updatedApi = updatedApi;
                })
                .error((error)=> {
                    // TODO handler updatedApi handler before showing
                });
            apiEdit.reset = (isManualReset) => {
                apiEdit.errorMessage = '';
                if (isManualReset) {
                    apiEdit.successMessage = '';
                }
            };
            apiEdit.udpate = () => {
                apiEdit.errorMessage = '';
                apiEdit.successMessage = '';
                ApiService.update($routeParams._id, {
                    url: apiEdit.updatedApi.url,
                    method: apiEdit.updatedApi.method,
                    handler: apiEdit.updatedApi.handler
                })
                    .success(() => {
                        apiEdit.successMessage = "Your Api has been successfully saved.";
                    })
                    .error((error) => {
                        apiEdit.errorMessage = error;
                    });
            };
        }
    ]);
})(angular);