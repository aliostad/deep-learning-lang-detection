
package com.seekting.study;

import android.app.Application;
import android.os.Handler;
import android.os.HandlerThread;

public class App extends Application {

    HandlerThread handlerThread;
    private Handler handler;
    public static App app;

    @Override
    public void onCreate() {
        super.onCreate();
        app = this;
        System.out.println("App.Oncreate");
        handlerThread = new HandlerThread("camera-manager");
        handlerThread.start();
        handler = new Handler(handlerThread.getLooper());
    }

    public Handler getHandler() {
        return handler;
    }

}
