package com.elevenware.ladybird.kit;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.HotSwapHandler;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;

public class AbstractHttpServingTestCase {

    private static Server jettyServer;
    private static HotSwapHandler hotSwapHandler;

    @BeforeClass
    public static void startServer() throws Exception {
        hotSwapHandler = new HotSwapHandler();
        jettyServer = new Server(8080);
        HandlerList handler = new HandlerList();
        handler.addHandler(hotSwapHandler);
        jettyServer.setHandler(handler);
        jettyServer.start();
    }

    @Before
    public void setHandler() throws Exception {
        hotSwapHandler.setHandler(getRealHandler());
    }

    protected void setRealHandler(Handler handler) {
        hotSwapHandler.setHandler(handler);
    }

    protected Handler getRealHandler() {
        return new CannedResponseHandler();
    }

    @AfterClass
    public static void stopServer() throws Exception {
        jettyServer.stop();
    }

}
