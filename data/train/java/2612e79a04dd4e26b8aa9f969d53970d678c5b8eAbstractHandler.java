/**   
* @Title: AbstractHandler.java 
* @Package com.brucelee.javapatterns.chainofresponsibity 
* @Description: TODO(用一句话描述该文件做什么) 
* @author robertlee1059@163.com   
* @date 2015-4-1 下午5:05:23 
*/
package com.brucelee.javapatterns.chainofresponsibity;

/** 
 * @ClassName: AbstractHandler 
 * @Description: TODO(这里用一句话描述这个类的作用) 
 * @author robertlee1059@163.com 
 * @date 2015-4-1 下午5:05:23 
 *  
 */
public abstract class AbstractHandler {
	private Handler handler;

	/**
	 */
	public Handler getHandler() {
		return handler;
	}

	/**
	 * @param handler the handler to set
	 */
	public void setHandler(Handler handler) {
		this.handler = handler;
	}
	
}
