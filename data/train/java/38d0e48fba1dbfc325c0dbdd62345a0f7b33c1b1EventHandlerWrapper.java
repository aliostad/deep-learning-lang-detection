package jchef.eventHandler;

import jchef.events.Event;

public abstract class EventHandlerWrapper extends EventHandler {

    private EventHandler wrappedHandler;

    protected EventHandlerWrapper(EventHandler wrappedHandler, String... events) {
        super(events);
        this.wrappedHandler = wrappedHandler;
    }

    @Override
    protected boolean checkPrerequisites()
    {
        return wrappedHandler.checkPrerequisites();
    }

    @Override
    protected void setActionData()
    {
        wrappedHandler.setActionData();
    }

    @Override
    protected void runAction()
    {
        wrappedHandler.runAction();
    }

    @Override
    protected void useEventInformation(Event event) {
        wrappedHandler.useEventInformation(event);
    }
}
