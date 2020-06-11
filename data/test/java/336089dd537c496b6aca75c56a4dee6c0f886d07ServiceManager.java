package com.teamteam.witherest.service.internal;

import org.apache.http.client.HttpClient;
import org.apache.http.conn.ClientConnectionManager;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.impl.conn.tsccm.ThreadSafeClientConnManager;
import org.apache.http.params.HttpParams;

import android.content.Context;
import android.os.Handler;

public class ServiceManager {
	
	private static  ServiceManager serviceManager = null;
	private ServiceHandler  handler = null;
	private HttpClient httpClient = null; 
	
	private UserService userService;
	private CategoryService categoryService;
	private VersionService versionService;
	private RoomService roomService;
	private ArticleService articleService;
	
	private ServiceManager(){
		handler = new ServiceHandler ();
		HttpClientFactory clientFactory = new HttpClientFactory();
		this.httpClient = clientFactory.getThreadSafeClient();
	}
	
	public static ServiceManager getServiceManager(){
		if (serviceManager == null){
			serviceManager = new ServiceManager();
		}
		return serviceManager;
	}
	public UserService getUserService() {
		if (userService== null){
			userService = new UserService(httpClient,handler);
		}
		return userService;
	}

	public CategoryService getCategoryService() {
		if (categoryService== null){
			categoryService= new CategoryService(httpClient,handler);
		}
		return categoryService;
	}

	public VersionService getVersionService() {
		if (versionService== null){
			versionService = new VersionService(httpClient,handler);
		}
		return versionService;
	}
	
	public RoomService getRoomService(){
		if (roomService == null){
			roomService = new RoomService(httpClient, handler);
		}
		return roomService;
	}
	
	public ArticleService getArticleService(){
		if ( articleService == null){
			 articleService= new ArticleService(httpClient, handler);
		}
		return  articleService;
	}
}
