package client.predictions.handler;

import java.util.ArrayList;
import java.util.List;
import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class ClientHandlerResolver implements HandlerResolver
{
    private final String name;
    private final String key;

    public ClientHandlerResolver( String name, String key )
    {
        this.name = name;
        this.key = key;
    }

    @Override
    public List<Handler> getHandlerChain( PortInfo portInfo )
    {
        List<Handler> handlerChain = new ArrayList<>();
        handlerChain.add( new IdHandler() );
        handlerChain.add( new ClientHashHandler( this.name, this.key ) );
        return handlerChain;
    }
}
