package samples.main.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class CustomHandlerResolver implements HandlerResolver
{
  private final List<Handler> chain;
  
  public CustomHandlerResolver()
  {
    chain = new ArrayList<Handler>(1);
    chain.add(new CustomMessageHandler());
  }
  
  public List<Handler> getHandlerChain(PortInfo portInfo)
  {
    return chain;
  }
}
