package com.bradmcevoy.http.http11;

import com.bradmcevoy.http.Handler;
import com.bradmcevoy.http.HandlerHelper;
import com.bradmcevoy.http.HttpExtension;
import java.util.HashSet;
import java.util.Set;

/**
 *
 * @author brad
 */
public class Http11Protocol implements HttpExtension{

    private final Set<Handler> handlers;

    public Http11Protocol( Set<Handler> handlers ) {
        this.handlers = handlers;
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
        handlers.add(new OptionsHandler(responseHandler, handlerHelper, enableOptionsAuth));
        handlers.add(new GetHandler(responseHandler, handlerHelper));
        handlers.add(new PostHandler(responseHandler, handlerHelper));
        handlers.add(new DeleteHandler(responseHandler, handlerHelper));
        handlers.add(new PutHandler(responseHandler, handlerHelper));
    }

    public Set<Handler> getHandlers() {
        return handlers;
    }
}
