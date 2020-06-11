package com.kiiik.handler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * MessageHandler消息分发器
 * 
 * @author YCL
 * 
 */
public class MessageHandlerDispatcher {

	private static Map<String, MessageHandler> handlers = new ConcurrentHashMap<String, MessageHandler>();

	/**
	 * 添加消息监听器
	 * 
	 * @param messageHandler
	 */
	public static void addHandler(String handlerInfo,
			MessageHandler messageHandler) {
		if (messageHandler == null) {
			throw new NullPointerException();
		}
		handlers.put(handlerInfo, messageHandler);
	}

	/**
	 * 移除消息监听器
	 * 
	 * @param messageHandler
	 */
	public static void removeHandler(String handlerInfo) {
		// handlers.remove(messageHandler);
		handlers.remove(handlerInfo);
	}

	/**
	 * 返回某特定消息监听器
	 * 
	 * @param handlerInfo
	 */
	public static MessageHandler getHandler(String handlerInfo) {
		return handlers.get(handlerInfo);
	}

	/**
	 * 判断某handler是否存在
	 * @param handlerInfo
	 * @return
	 */
	public static boolean isHandlerExist(String handlerInfo) {
		return handlers.containsKey(handlerInfo);
	}

	/**
	 * 获取所有消息处理器
	 * 
	 * @return
	 */
	public static Map<String, MessageHandler> getHandlers() {
		return handlers;
	}
}
