package com.zizibujuan.niubizi.client.ui;

import com.zizibujuan.niubizi.server.service.CategoryService;
import com.zizibujuan.niubizi.server.service.FileService;
import com.zizibujuan.niubizi.server.service.TagService;
import com.zizibujuan.niubizi.server.service.UserService;

public class ServiceHolder {
	private static ServiceHolder singleton;

	public static ServiceHolder getDefault() {
		return singleton;
	}

	public void activate() {
		singleton = this;
	}

	public void deactivate() {
		singleton = null;
	}
	
	private FileService fileService;
	public void unsetFileService(FileService fileService) {
		//logger.info("注销fileService");
		if (this.fileService == fileService) {
			this.fileService = null;
		}
	}
	public void setFileService(FileService fileService) {
		//logger.info("注入fileService");
		this.fileService = fileService;
	}
	public FileService getFileService() {
		return fileService;
	}
	
	private TagService tagService;
	public void unsetTagService(TagService tagService) {
		//logger.info("注销tagService");
		if (this.tagService == tagService) {
			this.tagService = null;
		}
	}
	public void setTagService(TagService tagService) {
		//logger.info("注入tagService");
		this.tagService = tagService;
	}
	public TagService getTagService() {
		return tagService;
	}
	
	private CategoryService categoryService;
	public void unsetCategoryService(CategoryService categoryService) {
		//logger.info("注销categoryService");
		if (this.categoryService == categoryService) {
			this.categoryService = null;
		}
	}
	public void setCategoryService(CategoryService categoryService) {
		//logger.info("注入categoryService");
		this.categoryService = categoryService;
	}
	public CategoryService getCategoryService() {
		return categoryService;
	}
	
	private UserService userService;
	public void unsetUserService(UserService userService) {
		//logger.info("注销userService");
		if (this.userService == userService) {
			this.userService = null;
		}
	}
	public void setUserService(UserService userService) {
		//logger.info("注入userService");
		this.userService = userService;
	}
	public UserService getUserService() {
		return userService;
	}
	
}
