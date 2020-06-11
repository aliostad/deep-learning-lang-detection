(function () {
    'use strict';
    define('DSVMobile.services',
        [
            'js/services_/LocalStorageService',
            'js/services_/LocalDBService',
            'js/services_/TranslatorService',
            'js/services_/UtilsService',
            'js/services_/LoginService',
            'js/services_/AppSettingsService',
            'js/services_/StopsService',
            'js/services_/StopDeviationsService',
            'js/services_/PhotoService',
            'js/services_/StopsInboxService',
            'js/services_/ReceiversService',
        ],
        function (LocalStorageService, 
        			LocalDBService, 
        			TranslatorService,
        			UtilsService,
        			LoginService,
        			AppSettingsService,
        			StopsService,
                    StopDeviationsService,
                    PhotoService,
                    StopsInboxService,
                    ReceiversService) {
            return angular.module('DSVMobile.services', [])
                .service('LocalStorageService', LocalStorageService)
                .service('LocalDBService', LocalDBService)
                .service('UtilsService', UtilsService)
                .service('LoginService', LoginService)
                .service('AppSettingsService', AppSettingsService)
                .service('StopsService', StopsService)
                .service('StopDeviationsService', StopDeviationsService)
                .service('PhotoService', PhotoService)
                .service('StopsInboxService', StopsInboxService)
                .service('TranslatorService', TranslatorService)
            	.service('ReceiversService', ReceiversService);
        });
})();