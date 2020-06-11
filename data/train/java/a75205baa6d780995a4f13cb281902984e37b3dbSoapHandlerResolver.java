package example.handlers.client;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by ThejKishore on 2/7/2017.
 */
public class SoapHandlerResolver implements HandlerResolver {

    @Override
    public List<Handler> getHandlerChain(PortInfo portInfo) {
        List<Handler> handlerChain = new ArrayList<Handler>();

        ClientSoapHandler  clientSoapHandler = new ClientSoapHandler();

        handlerChain.add(clientSoapHandler);

        return handlerChain;
    }
}
