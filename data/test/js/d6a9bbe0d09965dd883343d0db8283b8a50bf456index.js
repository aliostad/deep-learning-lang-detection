var UploadModalController = require('appstudio/view/modal/mediaGallery/UploadModalController');
var RenameModalController = require('appstudio/view/modal/screen/edit/RenameModalController');

var EditAppController = require('appstudio/view/modal/app/edit/EditAppController');
var NewApplicationController = require('appstudio/view/modal/app/new/NewApplicationController');

var NewBrandController = require('appstudio/view/modal/brand/new/NewBrandController');
var EditBrandController = require('appstudio/view/modal/brand/edit/EditBrandController');

var CreateScreenController = require('appstudio/view/modal/screen/new/CreateScreenController');
var AddComponentController = require('appstudio/view/modal/screen/new/AddComponentController');
var NewAppConfigController = require('appstudio/view/modal/appConfig/new/NewAppConfigController');
var NewBundleController = require('appstudio/view/modal/appConfig/new/NewBundleController');
var EditBundleController = require('appstudio/view/modal/appConfig/edit/EditBundleController');

var NewAssetModalController = require('appstudio/view/modal/theme/NewAssetModalController');
var AddSectionsModalController = require('appstudio/view/modal/appNavigation/AddSectionsModalController');

angular.module('appstudio.modals', []).run(function(){
    
})

.controller('editAppController', ['$uibModalInstance', 'customModalOption', '$controller', EditAppController])
.controller('newAppController', ['$uibModalInstance', 'customModalOption','$controller','modelFactory', 'modelOperation', NewApplicationController])

.controller('newAppConfigController', ['$uibModalInstance', 'customModalOption', 'modelFactory', 'modelOperation',  NewAppConfigController])
.controller('newBundleController', ['$uibModalInstance', 'customModalOption', 'modelFactory', 'modelOperation',  NewBundleController])
.controller('editBundleController', ['$uibModalInstance', 'customModalOption', 'modelFactory', 'modelOperation',  EditBundleController])

.controller('newBrandController', ['$uibModalInstance', 'customModalOption', '$controller', NewBrandController])
.controller('editBrandController',['$uibModalInstance', 'customModalOption', '$controller', EditBrandController])


.controller('uploadModalController',['$uibModalInstance', 'customModalOption', UploadModalController])
.controller('renameModalController',['$uibModalInstance', 'customModalOption', RenameModalController])

.controller('createScreenController', ['$uibModalInstance', 'customModalOption', '$controller', '$scope', CreateScreenController])

.controller('addComponentController', ['$uibModalInstance', 'customModalOption', '$controller', 'modelFactory', '$q', AddComponentController])

.controller('newAssetModalController', ['$uibModalInstance', 'customModalOption','$controller', NewAssetModalController])
.controller('addSectionModalController',['$uibModalInstance', 'customModalOption', AddSectionsModalController]);