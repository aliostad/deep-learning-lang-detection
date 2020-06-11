package com.lin1987www.os;

import android.os.Handler;
import android.os.HandlerThread;

/**
 * Created by lin on 2014/8/25.
 */
public class StartedHandler extends Handler {
    private final HandlerThread handlerThread;

    private StartedHandler(HandlerThread handlerThread, Callback callback) {
        super(handlerThread.getLooper(), callback);
        this.handlerThread = handlerThread;
    }

    public static StartedHandler create(String threadName, Callback callback) {
        HandlerThread handlerThread = new HandlerThread(threadName);
        handlerThread.start();
        StartedHandler startedHandler = new StartedHandler(handlerThread, callback);
        return startedHandler;
    }

    public void destroy() {
        handlerThread.quit();
        handlerThread.interrupt();
    }
}
