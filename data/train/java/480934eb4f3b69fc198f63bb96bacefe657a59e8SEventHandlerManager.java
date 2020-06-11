package com.cwa.simuiationimpl.event.handler;

import java.util.HashMap;
import java.util.Map;

import com.cwa.simuiation.event.IEventHandler;
import com.cwa.simuiation.event.ISEvent;
import com.cwa.simuiation.event.ISEventHandlerManager;

/**
 * 仿真器事件处理
 * 
 * @author mausmars
 * 
 */
public class SEventHandlerManager implements ISEventHandlerManager {
	// {事件类型：处理器}
	private Map<Integer, IEventHandler> eventHandlerMap = new HashMap<Integer, IEventHandler>();

	@Override
	public void handler(ISEvent event) {
		IEventHandler eventHandler = eventHandlerMap.get(event.getEventSubType());
		if (eventHandler != null) {
			eventHandler.handler(event);
		}
	}

	@Override
	public void insertEventHandler(IEventHandler eventHandler) {
		eventHandlerMap.put(eventHandler.getEventSubType(), eventHandler);
	}

	@Override
	public void removeEventHandler(int eventType) {
		eventHandlerMap.remove(eventType);
	}

	// ----------------------------------------------
	public void setEventHandlerMap(Map<Integer, IEventHandler> eventHandlerMap) {
		this.eventHandlerMap = eventHandlerMap;
	}
}
