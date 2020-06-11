package org.skk.tide.intnl;

import org.skk.tide.Event;
import org.skk.tide.EventHandler;
import org.skk.tide.HandleEvent;
import org.skk.tide.HandlerMethodNotFoundException;

import java.lang.ref.WeakReference;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class EventHandlerWrapper {

    private final WeakReference<EventHandler> weakHandler;

    public EventHandlerWrapper(EventHandler handler) {
        weakHandler = new WeakReference<EventHandler>(handler);
    }

    public boolean containsHandler(EventHandler handler) {
        EventHandler eventHandler = weakHandler.get();
        return eventHandler != null && eventHandler == handler;
    }

    public void invokeHandlerMethod(Event event) throws InvocationTargetException, IllegalAccessException, HandlerMethodNotFoundException {

        HandlerMethod handlerMethod = getHandlerMethod(event);
        handlerMethod.invoke();

    }

    private Method getHandlerMethodFor(EventHandler handler, Class<? extends Event> eventClass) throws HandlerMethodNotFoundException {

        if (handler == null) return null;

        Method[] declaredMethods = handler.getClass().getDeclaredMethods();
        for (Method method : declaredMethods) {
            if (isHandleMethodFor(method, eventClass)) {
                return method;
            }
        }

        throw new HandlerMethodNotFoundException(handler.getClass(), eventClass);
    }

    private boolean isHandleMethodFor(Method method, Class event) {

        HandleEvent annotation = method.getAnnotation(HandleEvent.class);

        return annotation != null && annotation.eventType().equals(event);
    }


    private HandlerMethod getHandlerMethod(Event event) throws HandlerMethodNotFoundException {

        EventHandler handler = weakHandler.get();

        Method handlerMethod = getHandlerMethodFor(handler, event.getClass());

        return HandlerMethod.get(handler, handlerMethod, event);

    }
}

