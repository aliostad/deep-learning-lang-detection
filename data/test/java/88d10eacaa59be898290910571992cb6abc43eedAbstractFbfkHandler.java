/**   
* @Title: AbstractFbfkHandler.java 
* @Package com.tyyd.ywpt.schedule.fkfb.handler 
* @Description:  
* @author wangyu   
* @date 2015-5-5 上午11:17:41 
* @CopyRight 天翼阅读
* @version V1.0   
*/
package com.tyyd.ywpt.schedule.fkfb.handler;

/**
 * @author wangyu
 *
 */
public abstract class AbstractFbfkHandler {

	private AbstractFbfkHandler handler;
	
	/**
	 * 每个子handler的处理方法
	 */
	public abstract void handleRequest();

	/**
	 * @return the handler
	 */
	public AbstractFbfkHandler getHandler() {
		return handler;
	}

	/**
	 * @param handler the handler to set
	 */
	public void setHandler(AbstractFbfkHandler handler) {
		this.handler = handler;
	}
	
	/**
	 * 处理方法
	 */
	protected void fbfkHandler() {
		
	}
	
}
