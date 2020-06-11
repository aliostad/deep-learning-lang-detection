package kr.oks.saboard.core.event.handler;

import java.util.List;

import org.springframework.context.ApplicationEvent;

public class EventHandlerAggregator implements ApplicationEventHandler {

	private List<ApplicationEventHandler> handlerList;

	public void setHandlerList(List<ApplicationEventHandler> handlerList) {
		this.handlerList = handlerList;
	}

	public void handle(ApplicationEvent event) throws Exception {
		for (ApplicationEventHandler handler : handlerList) {
			handler.handle(event);
		}
	}

	public List<ApplicationEventHandler> getHandlerList() {
		return handlerList;
	}
}
