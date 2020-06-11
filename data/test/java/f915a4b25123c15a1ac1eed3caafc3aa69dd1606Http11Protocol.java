package com.bradmcevoy.http.http11;

import com.bradmcevoy.http.Handler;
import com.bradmcevoy.http.HandlerHelper;
import com.bradmcevoy.http.HttpExtension;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 *
 * @author brad
 */
public class Http11Protocol implements HttpExtension{

    private final Set<Handler> handlers;

    private final HandlerHelper handlerHelper;

    private List<CustomPostHandler> customPostHandlers;

    public Http11Protocol( Set<Handler> handlers, HandlerHelper handlerHelper ) {
        this.handlers = handlers;
        this.handlerHelper = handlerHelper;
    }

    /**
     * OPTIONS authentication is disabled by default
     *
     * @param responseHandler
     * @param handlerHelper
     */
    public Http11Protocol(Http11ResponseHandler responseHandler, HandlerHelper handlerHelper) {
        this(responseHandler, handlerHelper, false );
    }

    public Http11Protocol(Http11ResponseHandler responseHandler, HandlerHelper handlerHelper, boolean enableOptionsAuth) {
        this.handlers = new HashSet<Handler>();
        this.handlerHelper = handlerHelper;
        handlers.add(new OptionsHandler(responseHandler, handlerHelper, enableOptionsAuth));
        handlers.add(new GetHandler(responseHandler, handlerHelper));
        handlers.add(new PostHandler(responseHandler, handlerHelper));
        handlers.add(new DeleteHandler(responseHandler, handlerHelper));
        handlers.add(new PutHandler(responseHandler, handlerHelper));
    }

    public Set<Handler> getHandlers() {
        return handlers;
    }

    public HandlerHelper getHandlerHelper() {
        return handlerHelper;
    }

    public List<CustomPostHandler> getCustomPostHandlers() {
        return customPostHandlers;
    }
}
