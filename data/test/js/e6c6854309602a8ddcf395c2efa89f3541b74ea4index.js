"use strict";

var AddAccountModalController = require('cms/view/modal/account/AddAccountModalController');
var AddBucketModalController = require('cms/view/modal/buckets/AddBucketModalController');
var AddContentFieldModalController = require('cms/view/modal/contentField/contentType/AddContentFieldModalController');
var AddContentListModalController = require('cms/view/modal/contentLists/AddContentListModalController');
var AddContentTypeModalController = require('cms/view/modal/contentType/AddContentTypeModalController');
var AddExistingUserMemberModalController = require('cms/view/modal/members/AddExistingUserMemberModalController');
var AddImageModalController = require('cms/view/modal/contentField/contentNode/AddImageModalController');
var AddImageTypeModalController = require('cms/view/modal/contentField/contentNode/AddImageTypeModalController');
var AddMemberModalController = require('cms/view/modal/members/AddMemberModalController');
var AddUserModalController =  require('cms/view/modal/user/AddUserModalController');
var ContentNodeAvailabilityModalController = require('cms/view/modal/contentNode/ContentNodeAvailabilityModalController');
var ContentNodeBucketPickerModalController = require('cms/view/modal/contentNode/ContentNodeBucketPickerModalController');
var ContentNodePickerModalController = require('cms/view/modal/contentNode/ContentNodePickerModalController');
var CustomizeSummaryModalController = require('cms/view/modal/contentType/CustomizeSummaryModalController');
var DeleteContentModalController = require('cms/view/modal/layout/DeleteContentModalController');
var DeleteNodeModalController = require('cms/view/modal/contentNode/DeleteNodeModalController');

angular.module('cms.modals', []).run(function(){})
	.controller('addAccountModalController', AddAccountModalController)
	.controller('addBucketModalController', AddBucketModalController)
	.controller('addContentFieldModalController', AddContentFieldModalController)
	.controller('addContentListModalController', AddContentListModalController)
	.controller('addContentTypeModalController', AddContentTypeModalController)
	.controller('addExistingUserMemberModalController', AddExistingUserMemberModalController)
	.controller('addImageModalController', AddImageModalController)
	.controller('addImageTypeModalController', AddImageTypeModalController)
	.controller('addMemberModalController', AddMemberModalController)
	.controller('addUserModalController', AddUserModalController)
	.controller('contentnodeAvailabilityModalController', ContentNodeAvailabilityModalController)
	.controller('contentNodeBucketPickerModalController', ContentNodeBucketPickerModalController)
	.controller('contentNodePickerModalInstanceCtrl', ContentNodePickerModalController)
	.controller('customizeSummaryModalController', CustomizeSummaryModalController)
	.controller('deleteContentModalController', DeleteContentModalController)
	.controller('deleteNodeModalController', DeleteNodeModalController)
;
