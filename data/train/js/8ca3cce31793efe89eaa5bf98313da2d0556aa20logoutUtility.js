app.service('logoutUtility', ['policyDataDbService', 'personalDataDbService', 'advisorDataDbService', 'clientListDbService', 'notificationDbService', 'policyDataService', 'barChartService', 'reminderService', 'loadingService', 'tutorialManager', 'credentialManager', function(policyDataDbService,personalDataDbService,advisorDataDbService,clientListDbService,notificationDbService,
                                     policyDataService,barChartService,reminderService,loadingService,tutorialManager,credentialManager) {
    //var currency_g;
    var modal = {};

    return {
        destroyScope : function() {
            advisorDataDbService.destroy();
            barChartService.destroy();
            clientListDbService.destroy();
            credentialManager.destroy();
            notificationDbService.destroy();
            personalDataDbService.destroy();
            policyDataDbService.destroy();
            policyDataService.destroy();
            reminderService.destroy();
            tutorialManager.destroy();
        }
    }
}]);