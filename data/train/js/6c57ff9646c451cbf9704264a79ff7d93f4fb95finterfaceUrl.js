define({

	/**
	 * /index
	 */
	queryServiceTag : 'admin/serviceTag/query.do',
	queryAuditServiceTags : 'admin/serviceTag/queryAuditServiceTags.do',
	uodateServiceTag : 'admin/serviceTag/update.do',
	removeServiceTag : 'admin/serviceTag/remove.do',
	addServiceTag : 'admin/serviceTag/add.do',
	uoloadServiceTagImage : 'admin/serviceTag/uploadServiceTagImage.do',
	getAuditById : 'admin/serviceTag/getAuditById.do',
	checkAuditServiceTag : 'admin/serviceTag/checkAuditServiceTag.do',
	unCheckAuditServiceTag : 'admin/serviceTag/unCheckAuditServiceTag.do',
	getAuditByServiceTagId : 'admin/serviceTag/getAuditByServiceTagId.do',
	updateAuditServiceTag : 'admin/serviceTag/updateAuditServiceTag.do',

	/**
	 * /service/user
	 */
	queryUserGroupList : 'admin/userGroup/queryGroupList.do',
	queryUserList : 'admin/userGroupRelUser/queryUserList.do',
	createUserGroup : 'admin/userGroup/addGroup.do',
	editUserGroup : 'admin/userGroup/editGroup.do',
	delUserGroup : 'admin/userGroup/delGroup.do',
	moveToBlack : 'admin/userGroupRelUser/moveToBlack.do',
	moveOutBlack : 'admin/userGroupRelUser/moveOutBlack.do',
	addUserToGroup : 'admin/userGroupRelUser/addUserToGroup.do',

	/**
	 * /service/message
	 */
	queryMessageList : 'admin/messageBox/queryMessageList.do',
	replyMessage : 'admin/replyMessage/replyMessage.do',

	/**
	 * /service/custom/survey
	 */
	getQuestClassList : 'admin/quest/getQuestClassList.do',
	addQuest : 'admin/quest/addQuest.do',
	delQuest : 'admin/quest/delQuest.do',
	publishQuest : 'admin/quest/publishQuest.do',
	queryQuestPageList : 'admin/quest/queryQuestPageList.do',

	/**
	 * /service/custom/article
	 */
	uploadTeletextImage : 'admin/service/uploadTeletextImage.do',

	/**
	 * /service/custom/reward
	 */
	uploadRewardFiles : 'admin/service/uploadRewardFiles.do',
	saveServiceReward : 'admin/service/saveServiceReward.do',
	publishServiceReward : 'admin/service/publishServiceReward.do',
	republishServiceReward : 'admin/service/republishServiceReward.do',
	queryRewardIdeas : 'admin/service/queryRewardIdeas.do',
	queryAllIdeasAtEnd : 'admin/service/queryAllIdeasAtEnd.do',
	setCreative : 'admin/service/setCreative.do',
	closeReward : 'admin/service/closeReward.do',

	/**
	 * /service/custom
	 */
	queryService : 'admin/service/query.do',
	endService : 'admin/service/endService.do',
	getServiceDetail : 'admin/service/getServiceDetail.do',
	publishServiceById : 'admin/service/publishServiceById.do',
	saveService : 'admin/service/saveServiceDetail.do',
	publishService : 'admin/service/publishService.do',
	republishService : 'admin/service/republishService.do',
	uploadAddtionFiles : 'admin/service/uploadAddtionFiles.do',

	/**
	 * /login
	 */
	login : 'login.do',
	logout : 'logout.do'

});