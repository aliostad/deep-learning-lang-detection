package cn.aleda.spring.service;

import cn.aleda.spring.service.interfaces.ArticleService;
import cn.aleda.spring.service.interfaces.MessageService;
import cn.aleda.spring.service.interfaces.PhotoService;
import cn.aleda.spring.service.interfaces.UserService;
import cn.aleda.spring.service.interfaces.WebsiteService;

public class ServiceManager {
	private UserService userService;
	private ArticleService articleService;
	private WebsiteService websiteService;
	private MessageService messageService;
	private PhotoService photoService;

	// ServiceManager用来管理服务
	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}

	public ArticleService getArticleService() {
		return articleService;
	}

	public void setArticleService(ArticleService articleService) {
		this.articleService = articleService;
	}

	public WebsiteService getWebsiteService() {
		return websiteService;
	}

	public void setWebsiteService(WebsiteService websiteService) {
		this.websiteService = websiteService;
	}

	public MessageService getMessageService() {
		return messageService;
	}

	public void setMessageService(MessageService messageService) {
		this.messageService = messageService;
	}

	public PhotoService getPhotoService() {
		return photoService;
	}

	public void setPhotoService(PhotoService photoService) {
		this.photoService = photoService;
	}
	
	
	
}
