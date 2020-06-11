package com.eclubprague.cardashboard.core.application;

import android.os.Handler;

/**
 * Created by Michael on 11. 8. 2015.
 */
public class HandlerTimer {

    private final Runnable handlerLaunchingTask;

    private final Handler handler = new Handler();

    public HandlerTimer(final Runnable task, final long interval) {
        this.handlerLaunchingTask = new Runnable() {
            @Override
            public void run() {
                task.run();
                handler.postDelayed(this, interval);
            }
        };
    }

    public void start(long delay) {
        handler.postDelayed(handlerLaunchingTask, delay);
    }

    public void stop() {
        handler.removeCallbacks(handlerLaunchingTask);
    }
}
