var ServiceFactory = {
    getJvmService: function () {
        return jvmService;
    },
    getGroupService: function () {
        return groupService;
    },
    getWebServerService: function () {
        return webServerService;
    },
    getWebAppService: function () {
        return webAppService;
    },
    getUserService: function () {
        return userService;
    },
    getAdminService: function() {
    	return adminService;
    },
    getResourceService: function() {
        return resourceService;
    },
    getServerStateWebSocketService: function() {
        return serverStateWebSocketService;
    },
    getMediaService: function () {
        return mediaService;
    }
};
