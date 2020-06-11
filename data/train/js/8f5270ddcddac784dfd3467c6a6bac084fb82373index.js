var AppTypeService = require('appstudio/service/appType/AppTypeService');
var AppService = require('appstudio/service/app/AppService');
var BrandDataService = require('appstudio/service/brand/BrandDataService');
var UIConfigurationService = require('appstudio/service/uiConfigurationService/UIConfigurationService');
var MediaGalleryService = require('appstudio/service/mediaGallery/MediaGalleryService');
var ScreenService = require('appstudio/service/screen/ScreenService');
var AppNavService = require('appstudio/service/appNavigation/AppNavService');
var ToastService = require('appstudio/service/toast/ToastService');

angular.module('appstudio.services', []).run(function(){

})
.service('appService', ['$q', 'httpService', 'modelFactory', AppService])
.service('brandDataService', ['$q', 'httpUploadService', 'appService', BrandDataService])
.service('uiConfigurationService', ['httpService', '$q', 'modelFactory', UIConfigurationService])
.service('appTypeService', ['httpService', '$q', AppTypeService])
.service('mediaGalleryService', ['$q', 'httpUploadService', '$log', 'modelFactory', MediaGalleryService])
.service('screenService', ['$q', 'httpService', 'modelFactory', ScreenService])
.service('appNavigationService', ['$q', 'httpService', 'modelFactory', AppNavService])
.service('toastService', ['utToast', ToastService]);
