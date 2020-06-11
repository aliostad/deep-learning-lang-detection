package com.zemosolabs.zetarget.sdk;

/**
 * Created by praveen on 21/01/15.
 */
import android.os.Handler;
import android.os.HandlerThread;

public class Worker extends HandlerThread {

    private Handler handler;

    public Worker(String name) {
        super(name);
    }


    Handler getHandler() {
        return handler;
    }

    void post(Runnable r) {
        assignHandler();
        handler.post(r);
    }

    void postDelayed(Runnable r, long delayMillis) {
        assignHandler();
        handler.postDelayed(r, delayMillis);
    }

    void removeCallbacks(Runnable r) {
        assignHandler();
        handler.removeCallbacks(r);
    }

    private synchronized void assignHandler() {
        if (handler == null) {
            handler = new Handler(getLooper());
        }
    }
}