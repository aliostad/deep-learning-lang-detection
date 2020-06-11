package com.action;


import javax.annotation.Resource;

import com.opensymphony.xwork2.ActionSupport;
import com.service.ArticleService;
import com.service.CommentService;
import com.service.MenuService;
import com.service.ModuleService;
import com.service.PostionService;
import com.service.UserService;
public abstract class BaseAction<T> extends ActionSupport {
	@Resource(name="userService")
	protected UserService userService;
	@Resource(name="articleService")
	protected ArticleService articleService;
	@Resource(name="moduleService")
	protected ModuleService moduleService;
	@Resource(name="commentService")
	protected CommentService commentService;
	@Resource(name="menuService")
	protected MenuService menuService;
	@Resource(name="postionService")
	protected PostionService postionService;
	
}
