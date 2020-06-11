package eu.nets.oss.jetty;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ResourceHandler;

public class HandlerBuilder<T extends Handler> {
    private final T handler;

    public HandlerBuilder(T handler) {
        this.handler = handler;
    }

    public T getHandler() {
        return handler;
    }

    public HandlerBuilder<T> setResourceHandler(ResourceHandler resourceHandler) {
        ((ContextHandler) handler).setHandler(resourceHandler);
        return this;
    }
}