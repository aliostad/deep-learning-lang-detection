package org.libsdl.app;


import android.app.Application;

public class MyAPP extends Application {  
	
	@Override  
    public void onCreate() {  
        super.onCreate();  
        CrashHandler crashHandler = CrashHandler.getInstance();  
        crashHandler.init(this);  
    }  
//	
//    // ¹²Ïí±äÁ¿  
//    private MyHandler handler = null;  
//      
//    // set·½·¨  
//    public void setHandler(MyHandler mHandler) {  
//        this.handler = mHandler;  
//    }  
//      
//    // get·½·¨  
//    public MyHandler getHandler() {  
//        return handler;  
//    }  
}  