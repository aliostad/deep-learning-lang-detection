package org.jprotocol.framework.handler;



/**
 * A small DSL for setting up a tree of handlers
 * @author eliasa01
 */
public class HandlerDsl { 
    public static <T extends Handler<?, ?>> T root(T root, UpperHandler...asdfs) {
        setLowerHandler(root, asdfs);
        return root;
    }

    public static UpperHandler handler(Handler<?, ?> handler, UpperHandler...upperHandlers) {
        UpperHandler uh = new UpperHandler(handler);
        setLowerHandler(handler, upperHandlers);
        return uh;
    }
    public static UpperHandler[] handlers(UpperHandler...upperHandlers) {
        return upperHandlers;
    }
    private static void setLowerHandler(Handler<?, ?> lowerHandler, UpperHandler[] upperHandlers) {
        for (UpperHandler h : upperHandlers) {
            h.handler.setLowerHandler(lowerHandler);
        }
    }

    public static class UpperHandler {
        final Handler<?, ?> handler;

        UpperHandler(Handler<?, ?> handler) {
            this.handler = handler;
        }
    }
}
