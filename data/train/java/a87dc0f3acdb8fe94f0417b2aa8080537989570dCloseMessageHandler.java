package org.codehaus.xfire.jaxws.handler;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.LogicalHandler;
import javax.xml.ws.handler.soap.SOAPHandler;

import org.codehaus.xfire.handler.Phase;
import org.codehaus.xfire.jaxws.ServiceDelegate;

public class CloseMessageHandler
    extends AbstractJAXWSHandler
{
    public CloseMessageHandler(ServiceDelegate service)
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

            sh.close(soapContext);
        }
        else
        {
            handler.close(soapContext);
        }
    }
}
