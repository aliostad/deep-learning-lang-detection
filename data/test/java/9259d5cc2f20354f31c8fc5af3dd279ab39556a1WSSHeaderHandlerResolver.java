package com.bernard.storefront.security;

import java.util.ArrayList;
import java.util.List;
import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

public class WSSHeaderHandlerResolver implements HandlerResolver {

@SuppressWarnings("unchecked")
public List<Handler> getHandlerChain(PortInfo portInfo) {
      List<Handler> handlerChain = new ArrayList<Handler>();
      WSSUsernameTokenSecurityHandler handler = new WSSUsernameTokenSecurityHandler();
      handlerChain.add(handler);
      return handlerChain;
   }
}
