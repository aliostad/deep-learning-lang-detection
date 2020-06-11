package org.codehaus.xfire.jaxws.handler;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.LogicalHandler;
import javax.xml.ws.handler.MessageContext;
import javax.xml.ws.handler.soap.SOAPHandler;

import org.codehaus.xfire.handler.Phase;
import org.codehaus.xfire.jaxws.ServiceDelegate;

public class MessageHandler
    extends AbstractJAXWSHandler
{
    public MessageHandler(ServiceDelegate service)
    {
        super(service);
        setPhase(Phase.USER);
    }

    protected void invokeHandler(SOAPMessageContext soapContext, Handler handler)
    {
        if (handler instanceof LogicalHandler)
        {
            LogicalHandler lh = (LogicalHandler) handler;
            
        }
        else if (handler instanceof SOAPHandler)
        {
            SOAPHandler sh = (SOAPHandler) handler;

            sh.handleMessage(soapContext);
        }
        else
        {
            handler.handleMessage(soapContext);
        }
    }
}
