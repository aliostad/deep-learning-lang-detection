var ioc = {
		activityService : {
			type : "com.friendship.service.ActivityService",
			args : [ {
				refer : "dao"
			} ]
		},
		useractivityService : {
			type : "com.friendship.service.UseractivityService",
			args : [ {
				refer : "dao"
			} ]
		},
		//前台Action
		activityAction : {
			type : "com.friendship.web.ActivityAction",
			fields : {
				activityService : {
					refer : "activityService"
				},
				useractivityService : {
					refer : "useractivityService"
				},
				userService:{
					refer:"userService"
				},
				replyService:{
					refer:"replyService"
				}
			}
		},
		//后台管理Action
		activityAdminAction : {
			type : "com.friendship.web.ActivityAdminAction",
			fields : {
				activityService : {
					refer : "activityService"
				}
			}
		}
};