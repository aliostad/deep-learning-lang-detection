package com.jivesoftware.example.utils;

import android.os.Handler;
import android.os.HandlerThread;
import com.jivesoftware.example.destroyer.IDestroyable;

/**
 * Created by mark.schisler on 10/15/14.
 */
public class BackgroundThread implements IDestroyable {
    private final HandlerThread handlerThread;
    private final Handler handler;

    public BackgroundThread() {
        handlerThread = new HandlerThread(getClass().getName());
        handlerThread.start();
        handler = new Handler(handlerThread.getLooper());
    }

    @Override
    public void destroy() {
        handlerThread.quit();
    }

    public Handler getHandler() {
        return handler;
    }

}
