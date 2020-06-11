/**
 * Taicang mscz Inc.
 * Copyright (c) 2010-2013 All Rights Reserved.
 */
package com.tccz.tccz.core.service.util;

import java.util.HashMap;
import java.util.Map;

import com.tccz.tccz.common.util.exception.CommonException;

/**
 * 文件处理器工厂
 * 
 * @author narutoying09@gmail.com
 * @version $Id: FileHandlerFactory.java, v 0.1 2013-10-22 上午9:07:34
 *          narutoying09@gmail.com Exp $
 */
public class FileHandlerFactory {

	private final Map<String, FileHandler> handlersMap = new HashMap<String, FileHandler>();

	/**
	 * 获取指定的文件处理器
	 * 
	 * @param inputStream
	 * @param handlerName
	 * @return
	 */
	public FileHandler getFileHandler(String handlerName) {
		FileHandler fileHandler = handlersMap.get(handlerName);
		if (fileHandler == null) {
			throw new CommonException("未找到指定的文件处理器[" + handlerName + "]");
		} else {
			return fileHandler;
		}
	}

	public synchronized void registerFileHandler(FileHandler fileHandler) {
		String handlerName = fileHandler.getHandlerName();
		FileHandler handler = handlersMap.get(handlerName);
		if (handler == null) {
			handlersMap.put(handlerName, fileHandler);
		} else {
			throw new CommonException("已存在重复的文件处理器[" + handlerName + "]");
		}
	}
}
