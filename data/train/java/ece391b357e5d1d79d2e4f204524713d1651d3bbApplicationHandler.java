package com.pxxx.wgu.android.com.pxxx.wgu.android.logic.handler;

import android.app.Activity;

import com.pxxx.wgu.android.com.pxxx.wgu.android.logic.handler.sub.BluetoothHandler;
import com.pxxx.wgu.android.com.pxxx.wgu.android.logic.handler.sub.RestHandler;

/**
 * Created by walter on 12.07.14.
 */
public class ApplicationHandler {

    private static ApplicationHandler instance = null;
    //sub-handler references
    private BluetoothHandler bluetoothHandler;
    private RestHandler restHandler;


    private ApplicationHandler() {
        bluetoothHandler = new BluetoothHandler();
        restHandler = new RestHandler();
    }

    public static ApplicationHandler getInstance() {
        if (instance == null) {
            instance = new ApplicationHandler();
        }
        return instance;
    }

    public BluetoothHandler getBluetoothHandler(Activity activity) {
        this.bluetoothHandler.setActivity(activity);
        return this.bluetoothHandler;

    }

    public RestHandler getRestHandler(Activity activity){
        return null;
    }

}
