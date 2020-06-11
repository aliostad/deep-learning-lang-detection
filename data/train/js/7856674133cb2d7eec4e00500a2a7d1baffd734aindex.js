var WorkflowService = require('cms/service/WorkflowService');
var UserService = require('cms/service/UserService');
var SystemService = require('cms/service/SystemService');
var SignUpService = require('cms/service/SignUpService');
var MemberService = require('cms/service/MemberService');
var PageContext = require('cms/service/PageContext');
var ForgotPasswordService = require('cms/service/ForgotPasswordService');
var ContentListService = require('cms/service/ContentListService');
var ContentTypeService = require('cms/service/ContentTypeService');
var BucketService = require('cms/service/BucketService');
var DeviceService = require('cms/service/DeviceService');
var ContentTypeUnicastService = require('cms/service/ContentTypeUniCastService');
var AlignmentService = require('cms/service/AlignmentService'); 
var ContentFieldService = require('cms/service/ContentFieldService'); 
var ContentNodeService = require('cms/service/ContentNodeService');
var BrandService = require('cms/service/BrandService');
var ConfigurationService = require('cms/service/ConfigurationService');
var AssetService = require('cms/service/AssetService');
var AccountService = require('cms/service/AccountService');
var MediaService = require('cms/service/MediaService');
var RoleService = require('cms/service/RoleService');

module.exports = angular.module('cms.service', [])
.factory('pageContext', ['$timeout', PageContext])
.service('alignmentService', [AlignmentService])
.factory('accountService', ['$q', '$http', '$log', '$location', 'principal', AccountService])
.service('assetService', ['$q', 'httpService', '$upload', 'AssetModel', AssetService])
.service('configurationService', ['httpService', 'accountService',  '$q', ConfigurationService ])
.service('brandService', ['httpService', 'accountService', '$q', 'Upload', BrandService])
.service('contentTypeUnicastService', ['$rootScope', ContentTypeUnicastService])
.service('workflowService', ['httpService', WorkflowService])
.service('systemService', ['httpService', SystemService])
.service('forgotPasswordService', ['httpService', ForgotPasswordService])
.service('deviceService', ['httpService', 'accountService', DeviceService])
.service('contentNodeService', ['$q', '$http', '$log', 'Contentnode', 'accountService', ContentNodeService])
.service('contentFieldService', ['httpService', 'accountService', ContentFieldService])
.service('bucketService', ['httpService', 'accountService', BucketService])
.service('contentListService', ['httpService', 'accountService', ContentListService])
.service('contentTypeService', ['httpService', 'accountService', ContentTypeService])
.service('signUpService', ['httpService', SignUpService])
.service('memberService', ['accountService', 'httpService', MemberService])
.service('mediaService', ['$q', 'httpService', 'Upload', 'accountService', MediaService])
.service('userService', ['$q', 'httpService', UserService])
.service('roleService', ['httpService', RoleService]);
