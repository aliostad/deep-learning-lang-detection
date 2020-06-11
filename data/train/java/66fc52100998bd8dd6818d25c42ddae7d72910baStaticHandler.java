package org.niohiki.debateserver.handlers;

import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.niohiki.debateserver.Utils;

/**
 * @author Santiago Codesido Sanchez
 **/
public class StaticHandler extends ContextHandler {

    public StaticHandler() {
        super(Utils.staticResourceContext);
        ResourceHandler resourceHandler = new ResourceHandler();
        resourceHandler.setDirectoriesListed(true);
        resourceHandler.setResourceBase(Utils.staticResourcePath);
        setHandler(resourceHandler);
    }
}
