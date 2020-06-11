package com.soapwsse.handler;


import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;
 
/**
*
* @Author ThusharaAma
*/

public class HeaderHandlerResolver implements HandlerResolver {
    
public List<Handler> getHandlerChain(PortInfo portInfo) {
      List<Handler> handlerChain = new ArrayList<Handler>();
 
      HeaderHandler hh = new HeaderHandler();
 
      handlerChain.add(hh);
 
      return handlerChain;
   }
}
 