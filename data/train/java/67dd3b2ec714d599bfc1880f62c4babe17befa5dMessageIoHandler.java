package com.baidu.dudu.network.mina.handler;


import org.apache.mina.core.service.IoHandlerAdapter;

import com.baidu.dudu.framework.handler.IncomingMessageHandler;
import com.baidu.dudu.framework.message.DuDuMessage;

/**
 * @author rzhao
 */
public class MessageIoHandler extends IoHandlerAdapter {

    protected IncomingMessageHandler handler;

    protected void send(DuDuMessage message) {

    }

    public IncomingMessageHandler getHandler() {
        return handler;
    }

    public void setHandler(IncomingMessageHandler handler) {
        this.handler = handler;
    }
}
