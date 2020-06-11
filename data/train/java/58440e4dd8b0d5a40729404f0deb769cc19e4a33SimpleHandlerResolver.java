package org.codehaus.xfire.jaxws.handler;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class SimpleHandlerResolver
    implements HandlerResolver
{
    private List<Handler> handlers = new ArrayList<Handler>();

    public List<Handler> getHandlerChain(PortInfo portInfo)
    {
        return handlers;
    }

    public List<Handler> getHandlers()
    {
        return handlers;
    }

    public void setHandlers(List<Handler> handlers)
    {
        this.handlers = handlers;
    }
}
