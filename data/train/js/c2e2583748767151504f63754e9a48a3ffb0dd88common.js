var ioc = {
	// User
	userService : {
		type : "com.kline.core.service.impl.UserServiceImpl",
		fields : {
			dao : {
				refer : 'dao'
			}
		}
	},
	userModule : {
		type : "com.kline.core.ui.UserModule",
		fields : {
			userService : {
				refer : 'userService'
			}
		}
	},
	// Agent
	agentService : {
		type : "com.kline.core.service.impl.AgentServiceImpl",
		fields : {
			dao : {
				refer : 'dao'
			}
		}
	},
	agentModule : {
		type : "com.kline.core.ui.AgentModule",
		fields : {
			agentService : {
				refer : 'agentService'
			}
		}
	}
};
