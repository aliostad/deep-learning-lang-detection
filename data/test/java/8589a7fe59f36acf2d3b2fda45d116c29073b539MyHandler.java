package com.example.johnnyofsnow.myapplication;

import android.os.Handler;

/**
 * Created by johnnyofsnow on 16/1/2.
 */
public class MyHandler {
    private static Handler handler;

    public static Handler getHandler(Runnable myRunnable){
        if(handler == null){
            initHandler(myRunnable);
        }
        return handler;
    }

    private static void initHandler(Runnable myRunnable){
        handler = new Handler();
        handler.postDelayed(myRunnable,1000);
    }

    public static void stopMyHandler(){
        handler.removeCallbacksAndMessages(null);
    }

    public static void pauseMyHandler(Runnable myRunnable){
        handler.removeCallbacksAndMessages(myRunnable);
    }

    public static void resumeMyHandler(Runnable myRunnable){
        handler.postDelayed(myRunnable,1000);
    }
}
