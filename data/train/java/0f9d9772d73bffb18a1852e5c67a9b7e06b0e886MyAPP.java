package com.all.wirelessplayer;


import android.app.Application;

public class MyAPP extends Application {  
	
	@Override  
    public void onCreate() {  
        super.onCreate();  
        CrashHandler crashHandler = CrashHandler.getInstance();  
        crashHandler.init(this);  
    }  
//	
//    // �������  
//    private MyHandler handler = null;  
//      
//    // set����  
//    public void setHandler(MyHandler mHandler) {  
//        this.handler = mHandler;  
//    }  
//      
//    // get����  
//    public MyHandler getHandler() {  
//        return handler;  
//    }  
}  