package com.modong.control;

import android.os.Handler;

/**
 * Created by zt-2010271 on 2017/4/24.
 */

public class HandlerTip {
    private static HandlerTip mDelayded = new HandlerTip();
    private Handler handler;

    public HandlerTip() {
        handler = new Handler();
    }


    public static HandlerTip getInstance() {
        return mDelayded;
    }

    public Handler getHandler() {
        return handler;
    }

    public void postDelayed(int time, final HandlerCallback call) {
        handler.postDelayed(new Runnable() {
            @Override
            public void run() {
                call.postDelayed();
            }
        }, time);
    }

    public interface HandlerCallback {
        void postDelayed();
    }
}
