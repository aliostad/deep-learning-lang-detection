package com.hyd.redisfx.event;

/**
 * 使 EventHandler 对象能够有一个 id 属性
 *
 * @author yiding_he
 */
public class EventHandlerWrapper {

    private String id;

    private EventHandler eventHandler;

    public EventHandlerWrapper() {
    }

    public EventHandlerWrapper(EventHandler eventHandler) {
        this(String.valueOf(eventHandler.hashCode()), eventHandler);
    }

    public EventHandlerWrapper(String id, EventHandler eventHandler) {
        this.id = id;
        this.eventHandler = eventHandler;
    }

    public EventHandler getEventHandler() {
        return eventHandler;
    }

    public void setEventHandler(EventHandler eventHandler) {
        this.eventHandler = eventHandler;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
