"use strict";

var AccountsController = require('cms/view/page/account/AccountsController');
var AppConfigurationController = require('cms/view/page/home/AppConfigurationWidget/AppConfigurationController');
var BucketsController = require('cms/view/page/buckets/BucketsController');
var ChangePasswordController = require('cms/view/page/forgotPassword/ChangePasswordController');
var ContentFieldController = require('cms/view/page/contentField/contentNode/ContentFieldController');
var ContentHeaderController = require('cms/view/page/header/ContentHeaderController');
var ContentLibraryController = require('cms/view/page/home/ContentLibraryWidget/ContentLibraryController');
var ContentListsController = require('cms/view/page/contentLists/ContentListsController');
var ContentNodeListController = require('cms/view/page/contentNode/ContentNodeListController');
var ContentNodeEditController = require('cms/view/page/contentNode/ContentNodeEditController');
var ContentTypesController = require('cms/view/page/home/ContentTypesWidget/ContentTypesController');
var ContentTypeFieldController = require('cms/view/page/contentField/contentType/ContentTypeFieldController');
var ContentTypeListController = require('cms/view/page/contentType/ContentTypeListController');
var DatePickerController = require('cms/view/page/contentNode/DatePickerController');
var DeniedController = require('cms/view/page/access/DeniedController');
var ForgotPasswordController = require('cms/view/page/forgotPassword/ForgotPasswordController');
var HeaderController = require('cms/view/page/header/HeaderController');
var HomeController = require('cms/view/page/home/HomeController');
var MemberController = require('cms/view/page/members/MemberController');
var MembersController = require('cms/view/page/members/MembersController');
var SignInController = require('cms/view/page/access/SignInController');
var SignOutController = require('cms/view/page/access/SignOutController');
var SignUpController = require('cms/view/page/signUp/SignUpController');
var SignUpRequestsController = require('cms/view/page/signUp/SignUpRequestsController');
var TimePickerController = require('cms/view/page/contentNode/TimePickerController');
var UserController = require('cms/view/page/user/UserController');
var UserProfileEditController = require('cms/view/page/userprofile/UserProfileEditController');
var UsersController = require('cms/view/page/user/UsersController');


angular.module('cms.pages', []).run(function(){
	})
	.controller('accountsController', AccountsController)
	.controller('appConfigurationController', AppConfigurationController)
	.controller('bucketsController', BucketsController)
	.controller('changePasswordController', ChangePasswordController)
	.controller('contentFieldController', ContentFieldController)
	.controller('contentHeaderController', ContentHeaderController)
	.controller('contentLibraryController', ContentLibraryController)
	.controller('contentListsController', ContentListsController)
	.controller('contentNodeEditController', ContentNodeEditController)
	.controller('contentNodeListController', ContentNodeListController)
	.controller('contentTypesController', ContentTypesController)
	.controller('contentTypeFieldController', ContentTypeFieldController)
	.controller('contentTypeListController', ContentTypeListController)
	.controller('DatepickerDemoCtrl', DatePickerController)
	.controller('deniedController', DeniedController)
	.controller('forgotPasswordController', ForgotPasswordController)
	.controller('headerController', HeaderController)
	.controller('homeController', HomeController)
	.controller('memberController', MemberController)
	.controller('membersController', MembersController)
	.controller('signInController', SignInController)
	.controller('signOutController', SignOutController)
	.controller('signUpController', SignUpController)
	.controller('signUpRequestsController', SignUpRequestsController)
	.controller('TimepickerDemoCtrl', TimePickerController)
	.controller('userController', UserController)
	.controller('userProfileEditController', UserProfileEditController)
	.controller('usersController', UsersController);
