package com.GreenLemonMobile.util;

import android.os.Handler;
import android.os.Looper;

import java.util.concurrent.Executor;

public class HandlerExecutor implements Executor {
    public HandlerExecutor(Handler handler)
    {
        mHandler = handler;
    }

    public static HandlerExecutor getUiThreadExecutor()
    {
        return sUiThreadExecutor;
    }

    public void execute(Runnable runnable)
    {
        mHandler.post(runnable);
    }

    private static final HandlerExecutor sUiThreadExecutor = new HandlerExecutor(new Handler(Looper.getMainLooper()));
    private final Handler mHandler;
}
