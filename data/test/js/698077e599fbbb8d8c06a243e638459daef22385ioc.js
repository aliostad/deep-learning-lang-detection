var ioc = {
        manageService : {
                type : "com.fr.net.manage.service.ManageServiceImpl",
                fields : {
                        dao : {
                                refer : 'dao'
                        }
                }
        },
        manageAction : {
                type : "com.fr.net.manage.action.ManageAction",
                fields : {
                	manageService : {
                                refer : 'manageService'
                        }
                }
        },
        newsService : {
            type : "com.fr.net.manage.service.NewsServiceImpl",
            fields : {
                    dao : {
                            refer : 'dao'
                    }
            }
        },
	    newsAction : {
	            type : "com.fr.net.manage.action.NewsAction",
	            fields : {
	            	newsService : {
	                            refer : 'newsService'
	                    }
	            }
	    }
};