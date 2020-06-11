
define(['angularAMD' ], function (angularAMD) {
    angularAMD.controller('WorkflowDefinitionServiceSettingsModalController',
        [ '$scope', '$state', '$log', '$modalInstance', 'selectedService', 'service', 'serviceVersions','willBeCorrectFlowFlow',
            function ($scope, $state, $log, $modalInstance, selectedService, service, serviceVersions, willBeCorrectFlowFlow) {

                $scope.serviceVersions = serviceVersions;

                $scope.service = service;

                $scope.selectedService = {
                    id: selectedService.id,
                    serviceId: selectedService.serviceId,
                    orderNum: selectedService.orderNum,
                    serviceParamsValues:{}
                };

                for(i in selectedService.serviceParamsValues){
                    $scope.selectedService.serviceParamsValues[i] = selectedService.serviceParamsValues[i];
                }

                $scope.versionChanged = function () {

                    $scope.willBeCorrectFlowFlow = willBeCorrectFlowFlow( $scope.selectedService.serviceId );

                    for( var i = 0; i < serviceVersions.length; i++ ){
                        if( serviceVersions[i].id == $scope.selectedService.serviceId ){
                            var service = serviceVersions[i];
                            $scope.service = service;
                            $scope.selectedService.serviceParamsValues = {};
                            for(i in service.serviceParams){
                                var param = service.serviceParams[i];
                                $scope.selectedService.serviceParamsValues[param.key] = param.value;
                            }
                            break;
                        }
                    }
                };

                $scope.save = function () {
                    $modalInstance.close( $scope.selectedService );
                };
            }])
});