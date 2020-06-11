package cc.fozone.javascript.handler;

import java.util.Map;

import org.springframework.stereotype.Component;

import cc.fozone.javascript.IPropertyHandler;

/**
 * 控制器注册器
 * @author jimmy song
 *
 */
@Component
public class HandlerRegister {
	/**
	 * 获取控制器
	 * @param name 控制器名称
	 * @return 注释控制器
	 */
	public IPropertyHandler getHandler(String name){
		if(handlerMap == null) return null;
		return handlerMap.get(name);
	}
	
	private Map<String,IPropertyHandler> handlerMap;

	public Map<String, IPropertyHandler> getHandlerMap() {
		return handlerMap;
	}

	public void setHandlerMap(Map<String, IPropertyHandler> handlerMap) {
		this.handlerMap = handlerMap;
	}
	
}
