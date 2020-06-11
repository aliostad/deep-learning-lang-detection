package com.yumcouver.tunnel.client.proxy;

import com.yumcouver.tunnel.client.tunnel.TunnelHandler;
import com.yumcouver.tunnel.client.util.ClientHandler;
import com.yumcouver.tunnel.client.util.ConfigReader;

public class ProxyHandler extends ClientHandler {
    private final TunnelHandler tunnelHandler;

    public ProxyHandler(TunnelHandler tunnelHandler) {
        super(ConfigReader.DESTINATION_HOST,
                ConfigReader.DESTINATION_PORT,
                new ProxyHandlerAdapter(tunnelHandler));
        this.tunnelHandler = tunnelHandler;
    }

    @Override
    public synchronized void shutdown() {
        while (clientHandlerAdapter.isConnected()) {
            clientHandlerAdapter.shutdown();
        }
        workerGroup.shutdownGracefully();
        while (tunnelHandler != null && tunnelHandler.isConnected()) {
            tunnelHandler.shutdown();
        }
    }
}
