package handler;

import message.event.IGameEvent;

public abstract class AHandlerLink implements IGameEventHandler {

	private IGameEventHandler _nextHandlerLink;

	public AHandlerLink(IGameEventHandler handler){
		setNextHandlerLink(handler);
	}
	
	private void setNextHandlerLink(IGameEventHandler handler) {
		_nextHandlerLink = handler;
	}

	private IGameEventHandler getNextHandlerLink() {
		return (_nextHandlerLink);
	}

	public abstract void processEvent(IGameEvent gameEvent);

	public void handle(IGameEvent gameEvent) {
		processEvent(gameEvent);
		if (getNextHandlerLink() != null)
			getNextHandlerLink().handle(gameEvent);
	}

}
