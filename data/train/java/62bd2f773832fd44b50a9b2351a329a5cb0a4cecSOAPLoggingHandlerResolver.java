/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package io.neocdtv.jee.jaxwsclient;

import java.util.ArrayList;
import java.util.List;
import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;

/**
 *
 * @author xix
 */
public class SOAPLoggingHandlerResolver implements HandlerResolver{

    @Override
    public List<Handler> getHandlerChain(PortInfo portInfo) {
        List<Handler> handlerChain = new ArrayList<>();
        LogicalLoggingHandler handler = new LogicalLoggingHandler();
        handlerChain.add(handler);
        return handlerChain;
    }
    
}
