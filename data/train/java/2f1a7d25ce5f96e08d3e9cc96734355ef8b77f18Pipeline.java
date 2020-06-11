/**
 * iddl
 * 
 * Intelligent Distributed Data Layer
 * 
 * iddl-common
 */
package com.it.iddl.common.pipeline;

import java.sql.SQLException;

/**
 * 
 * @author sihai
 *
 */
public interface Pipeline {
	
	/**
	 * 
	 * @param name
	 * @param handler
	 */
	void addHead(String name, Handler handler);
	
	/**
	 * 
	 * @param name
	 * @param handler
	 */
	void addTail(String name, Handler handler);
	
	/**
	 * 
	 * @param baseName
	 * @param name
	 * @param handler
	 */
	void addBefore(String baseName, String name, Handler handler);

	/**
	 * 
	 * @param baseName
	 * @param name
	 * @param handler
	 */
	void addAfter(String baseName, String name, Handler handler);

	/**
	 * 
	 * @param handler
	 */
	void remove(Handler handler);

	/**
	 * 
	 * @param name
	 * @return
	 */
	Handler remove(String name);

	/**
	 * 
	 * @param <T>
	 * @param handlerType
	 * @return
	 */
	<T extends Handler> T remove(Class<T> handlerType);

	/**
	 * 
	 * @return
	 */
	Handler removeHead();

	/**
	 * 
	 * @return
	 */
	Handler removeTail();

	/**
	 * 
	 * @param oldHandler
	 * @param newName
	 * @param newHandler
	 */
	void replace(Handler oldHandler, String newName, Handler newHandler);

	/**
	 * 
	 * @param oldName
	 * @param newName
	 * @param newHandler
	 * @return
	 */
	Handler replace(String oldName, String newName, Handler newHandler);

	/**
	 * 
	 * @param <T>
	 * @param oldHandlerType
	 * @param newName
	 * @param newHandler
	 * @return
	 */
	<T extends Handler> T replace(Class<T> oldHandlerType, String newName,
			Handler newHandler);

	/**
	 * 
	 * @return
	 */
	Handler getHead();

	/**
	 * 
	 * @return
	 */
	Handler getTail();

	/**
	 * 
	 * @param name
	 * @return
	 */
	Handler get(String name);

	/**
	 * 
	 * @param handler
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	HandlerContext getContext(Handler handler);
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	HandlerContext getContext(String name);
	
	/**
	 * 
	 * @param handlerType
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	HandlerContext getContext(Class<? extends Handler> handlerType);

	/**
	 * 开始执行流程。pipeline持有所有HandlerContext。
	 * 直接调用调用头结点的HandlerContext.flowNext()
	 * 
	 * @param dataBus   数据总线
	 * @throws SQLException
	 */
	void startFlow(DataBus dataBus) throws SQLException;
	
	/**
	 * 重置管线
	 */
	void reset();
}
