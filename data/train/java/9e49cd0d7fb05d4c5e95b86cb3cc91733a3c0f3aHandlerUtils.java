package com.downloader.ui;

import android.os.Handler;

/**
 * <title></title> 
 * @author XiangYuan 
 * @version 0.1 
 * @time 2011-12-6
 * @mailto liyajie1209@gmail.com
 */
public class HandlerUtils {

    private Handler mHandler = null;
    
    private static HandlerUtils instance = null;
    
    private HandlerUtils() {
    }
    
    public static HandlerUtils getInstance() {
        if (instance == null) {
            instance = new HandlerUtils();
        }
        return (instance);
    }
    
    public void setHandler(Handler handler) {
        this.mHandler = handler;
    }
    
    public Handler getHandler() {
        return (mHandler);
    }
}
