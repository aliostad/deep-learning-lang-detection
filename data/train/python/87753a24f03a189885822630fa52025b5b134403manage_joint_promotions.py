# [Copyright]
# SmartPath v1.0
# Copyright 2014-2015 Mountain Pass Solutions, Inc.
# This unpublished material is proprietary to Mountain Pass Solutions, Inc.
# [End Copyright]

manage_joint_promotions = {
	"code": "manage_joint_promotions",
	"descr": "Manage Joint Secondary Promotions",
	"header": "Manage Joint Secondary Promotions",
	"componentType": "Task",
    "affordanceType":"Item",
	"optional": True,
	"enabled": True,
	"accessPermissions": ["dept_task"],
	"viewPermissions": ["ofa_task","dept_task"],
	"blockers": [],
	"containers": [],
    "statusMsg": "",
	"className": "JointPromotion",
	"config": {
		"instructional":"Select secondary positions and titles that will be included with this promotion."
	},

}
