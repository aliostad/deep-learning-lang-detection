package com.kuaileren.service;

import com.kuaileren.util.ToolsUtil;

public class InitServerImpl implements InitServer
{
    private UserService userService;
    private ArticleService articleService;
    @Override
    public void doInitAction() {
    	
    	ToolsUtil.initUser(userService);
    	ToolsUtil.initCountInfo(articleService);
    }
    
    
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	public void setArticleService(ArticleService articleService) {
		this.articleService = articleService;
	}
}
