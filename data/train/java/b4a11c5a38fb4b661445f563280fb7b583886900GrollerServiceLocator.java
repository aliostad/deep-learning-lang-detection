/*
 * Created on 2003-10-16
 */
package groller.application.service;

import groller.framework.service.ServiceLocator;

/**
 * @author xiongj
 * 	xiongj@hzjbbis.com.cn
 */
public class GrollerServiceLocator extends ServiceLocator {
	/*=====================================
	 * 在此注册需要使用的Service
	 * 并在application.bean.xml中详细声明
	 ====================================*/
	
	public UserService getUserService() {
		return (UserService) getService("userService", UserService.class);
	}
	
	public PostService getPostService() {
		return (PostService) getService("postService", PostService.class);
	}
}
