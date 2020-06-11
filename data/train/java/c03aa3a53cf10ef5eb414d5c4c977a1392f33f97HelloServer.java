package hellotwu.web;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.webapp.WebAppContext;

public class HelloServer {

    private final Server server;

    public HelloServer() {
        server = new Server(8080);
        server.setHandler(handlers());
    }

    public static void main(String... args) throws Exception {
        new HelloServer().start();
    }

    private void start() throws Exception {
        server.start();
        server.join();
    }

    private Handler handlers() {
        HandlerList handlerList = new HandlerList();
        handlerList.setHandlers(new Handler[]{webAppHandler()});

        HandlerCollection handlerCollection = new HandlerCollection();
        handlerCollection.addHandler(handlerList);

        return handlerCollection;
    }

    private Handler webAppHandler() {
        WebAppContext handler = new WebAppContext();
        handler.setWar("src/main/webapp");
        return handler;
    }
}
