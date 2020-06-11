package com.geekcommune.communication.handler;

import com.geekcommune.communication.Event;

public class ChainedHandler implements Handler {

    public ChainedHandler(Handler h1, Handler h2) {
        // TODO Auto-generated constructor stub
    }

    public void handle(Event obj) {
        // TODO Auto-generated method stub

    }

    public static Handler chainHandlers(Handler h1, Handler responseHandler) {
        if( h1 == null ) {
            return responseHandler;
        } else if( responseHandler == null ) {
            return h1;
        } else {
            return new ChainedHandler(h1, responseHandler);
        }
    }
}
