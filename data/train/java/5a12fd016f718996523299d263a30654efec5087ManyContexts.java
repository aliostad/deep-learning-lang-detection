package test.jetty.service;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;

import test.jetty.service.handler.HelloHandler;
 
public class ManyContexts
{
    public static void main(String[] args) throws Exception
    {
        Server server = new Server(8080);
 
        ContextHandler context = new ContextHandler("/");
        context.setContextPath("/");
        context.setHandler(new HelloHandler("Root Hello"));
 
        ContextHandler contextFR = new ContextHandler("/fr");
        contextFR.setHandler(new HelloHandler("Bonjoir"));
         
        ContextHandler contextIT = new ContextHandler("/it");
        contextIT.setHandler(new HelloHandler("Bongiorno"));
 
        ContextHandler contextV = new ContextHandler("/");
        contextV.setVirtualHosts(new String[]{ "127.0.0.2" });
        contextV.setHandler(new HelloHandler("Virtual Hello"));
 
        ContextHandlerCollection contexts = new ContextHandlerCollection();
        contexts.setHandlers(new Handler[] { context, contextFR, contextIT, contextV });
 
        server.setHandler(contexts);
 
        server.start();
        server.join();
    }
}
