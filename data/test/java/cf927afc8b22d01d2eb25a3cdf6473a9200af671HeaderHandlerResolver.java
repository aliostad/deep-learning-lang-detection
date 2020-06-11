package com.logica.ndk.tm.jbpm.ws;

import java.util.ArrayList;
import java.util.List;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;
import javax.xml.ws.handler.soap.SOAPHandler;
import javax.xml.ws.handler.soap.SOAPMessageContext;

public class HeaderHandlerResolver implements HandlerResolver {
  @SuppressWarnings("rawtypes")
  private List<Handler> handlerChain;

  @SuppressWarnings("rawtypes")
  public HeaderHandlerResolver(SOAPHandler<SOAPMessageContext> mainSOAPHandler) {
    handlerChain = new ArrayList<Handler>();
    handlerChain.add(mainSOAPHandler);
  }

  @SuppressWarnings("rawtypes")
  public List<Handler> getHandlerChain(PortInfo portInfo) {
    return handlerChain;
  }
}
