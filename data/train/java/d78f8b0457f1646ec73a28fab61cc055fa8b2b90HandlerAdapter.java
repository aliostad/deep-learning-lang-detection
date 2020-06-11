package com.example.androidmontreal.mvp.infrastructure.adapters;

import android.os.Handler;
import com.example.androidmontreal.mvp.domain.adapters.RunnableHandler;

public class HandlerAdapter implements RunnableHandler {

    private final Handler handler;

    public HandlerAdapter(Handler handler) {
        this.handler = handler;
    }

    @Override
    public void removeCallbacks(Runnable r) {
        handler.removeCallbacks(r);
    }

    @Override
    public void postDelayed(Runnable r, int delay) {
        handler.postDelayed(r, delay);
    }
}
