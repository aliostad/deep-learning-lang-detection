package uk.co.shastra.hydra.messaging.utils;

import java.util.AbstractSet;
import java.util.HashSet;

public class EventNoData {

	private AbstractSet<EventHandlerNoData> handlers = new HashSet<EventHandlerNoData>();
	
	public void addHandler(EventHandlerNoData handler) {
		handlers.add(handler);
	}
	
	public void removeHandler(EventHandlerNoData handler) {
		handlers.remove(handler);
	}
	
	public void removeAllHandlers() {
		handlers.clear();
	}
	
	public void raise(Object source) {
		for (EventHandlerNoData handler : handlers) {
			handler.handle(source);
		}
	}
}
