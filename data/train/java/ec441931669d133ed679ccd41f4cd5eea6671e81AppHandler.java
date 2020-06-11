/*
 * Copyright (c) 2015 huwentao (vernon.huwt@gmail.com)
 */

package com.example.mokey.weekport.ui.core;

import android.os.Handler;
import android.os.Message;

import java.lang.ref.WeakReference;

/**
 * Created by mokey on 2015/8/11.
 */
public abstract class AppHandler {
    private StaticHandler handler;

    public StaticHandler getHandler(BaseActivity baseActivity) {
        handler = new StaticHandler(this, baseActivity);
        return handler;
    }

    /**
     * 结束当前Handler事件处理
     */
    public void interrup() {
        if (handler != null) {
            handler.interrupt();
            handler = null;
        }
    }

    public abstract void handleMessage(Message msg);

    public static class StaticHandler extends Handler {
        WeakReference<BaseActivity> weakReference = null;
        AppHandler appHandler = null;
        boolean isInterrup = false;

        public StaticHandler(AppHandler appHandler, BaseActivity baseActivity) {
            this.weakReference = new WeakReference<>(baseActivity);
            this.appHandler = appHandler;
        }

        @Override
        public void handleMessage(Message msg) {
            if (!isInterrup) {
                appHandler.handleMessage(msg);
            }
        }

        /**
         * 结束Handler事件处理
         */
        public void interrupt() {
            isInterrup = true;
            weakReference.clear();
            weakReference = null;
        }

    }

    public StaticHandler getHandler() {
        return handler;
    }
}
