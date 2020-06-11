package com.kisel.handlers;

import java.io.OutputStream;

/**
 *
 * @author brainless
 */
public abstract class MessageHandler {

    protected MessageHandler nextHandler;
    protected DBHandler dbHandler;

    public MessageHandler() {
    }

    public MessageHandler(MessageHandler nextHandler, DBHandler dbHandler) {
        this.nextHandler = nextHandler;
        this.dbHandler = dbHandler;
    }

    public void handleMessage(byte[] message, OutputStream outputStream) {
        if (nextHandler != null) {
            nextHandler.handleMessage(message, outputStream);
        }
    }
}
