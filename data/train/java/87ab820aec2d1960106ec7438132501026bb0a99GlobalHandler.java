package com.wj.kindergarten.handler;

import android.os.Handler;
import android.os.Message;

import java.util.ArrayList;
import java.util.List;

/**
 * 消息处理
 *
 * @author 邹彭强
 */

public class GlobalHandler extends Handler {
    private static GlobalHandler handler = new GlobalHandler();
    private List<MessageHandlerListener> listeners;

    private GlobalHandler() {
        listeners = new ArrayList<MessageHandlerListener>();
    }

    public static GlobalHandler getHandler() {
        return handler;
    }

    public void addMessageHandlerListener(MessageHandlerListener listener) {
            handler.listeners.add(listener);
    }

    @Override
    public void handleMessage(Message msg) {
        if (handler.listeners != null && handler.listeners.size() > 0) {
            for (MessageHandlerListener listener : listeners) {
                listener.handleMessage(msg);
            }
        }
    }
}
