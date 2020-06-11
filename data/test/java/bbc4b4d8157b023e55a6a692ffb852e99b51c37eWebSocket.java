package org.m410.garden.controller.action.ws;

/**
 * Add a websocket listener to a controller.
 *
 *
 * @author m410
 */
public class WebSocket {
    private CloseHandler closeHandler = (s)->{} ;
    private OpenHandler openHandler = (s)->{};
    private ErrorHandler errorHandler = (s)->{};
    private MessageHandler messageHandler = (s)->{};

    public WebSocket(CloseHandler closeHandler, OpenHandler openHandler,
             ErrorHandler errorHandler, MessageHandler messageHandler) {
        this.closeHandler = closeHandler;
        this.openHandler = openHandler;
        this.errorHandler = errorHandler;
        this.messageHandler = messageHandler;
    }

    public WebSocket() {
    }

    public WebSocket open(OpenHandler openHandler) {
        return new WebSocket(closeHandler,openHandler,errorHandler,messageHandler);
    }

    public WebSocket close(CloseHandler closeHandler) {
        return new WebSocket(closeHandler,openHandler,errorHandler,messageHandler);
    }

    public WebSocket message(MessageHandler messageHandler) {
        return new WebSocket(closeHandler,openHandler,errorHandler,messageHandler);
    }

    public WebSocket error(ErrorHandler errorHandler) {
        return new WebSocket(closeHandler,openHandler,errorHandler,messageHandler);
    }

}
