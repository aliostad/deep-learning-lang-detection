package com.scoa.roadrunner.services.jaxws.handler;

import javax.xml.ws.handler.Handler;
import javax.xml.ws.handler.HandlerResolver;
import javax.xml.ws.handler.PortInfo;
import java.util.ArrayList;
import java.util.List;

/**
 *
 *
 *
 */
public class ClientHandlerResolver implements HandlerResolver {


    @Override
    public List<Handler> getHandlerChain(PortInfo portInfo) {
        List<Handler> chain = new ArrayList<>();
        chain.add(new SoapHeaderCredentialsHandler());
        chain.add(new SoapLoggingHandler());
        return chain;
    }

}
