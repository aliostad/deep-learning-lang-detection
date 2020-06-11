package com.gauk10.api.infrastructure;

import io.undertow.server.HttpHandler;
import io.undertow.server.RoutingHandler;

/**
 * Created by devblox on 2/21/16.
 */
public final class RestHandlerBuilder implements HandlerBuilder {

    private RoutingHandler handler;

    public RestHandlerBuilder() {
        handler = new RoutingHandler();
    }

    public RestHandlerBuilder addHandler(String template, HttpHandler handler) {
        this.handler.add("GET", template, handler);
        return this;
    }

    @Override
    public HttpHandler build() {
        return handler;
    }
}
