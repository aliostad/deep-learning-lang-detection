/*
 * Copyright (C) 2013 eNitiatives Pty. Ltd.
 */
package org.EzAz.Layer3Driver.ViewDsSOAP;
import java.util.ArrayList;
import java.util.List;
import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

/**
 *
 * @author mennis
 */
public class LocalHandlerResolver
        implements HandlerResolver
{
    Handler handler;
    
    public LocalHandlerResolver()
    {
        handler = new LocalHandler(null, null);
    }
    
    public LocalHandlerResolver(String username, String password)
    {
        handler = new LocalHandler(username, password);
    }
    
    @Override
    public List<Handler> getHandlerChain(PortInfo portInfo)
    {
        List<Handler> handlers;
        
        handlers = new ArrayList<Handler>();
        handlers.add(handler);
        return handlers;
    }
}
