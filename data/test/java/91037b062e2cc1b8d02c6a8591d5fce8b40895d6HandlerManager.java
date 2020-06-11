package com.android.sunning.riskpatrol.system;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import android.os.Message;

/**
 * Created by sunning on 14-9-29.
 */
public class HandlerManager {

    private static HandlerManager instance ;

    private Map<HandlerCallBackListener,SunnyHandler> handlerContainer ;

    public static HandlerManager getInstance() {
        if(instance == null){
            syncInit() ;
        }
        return instance ;
    }

    private static synchronized void syncInit() {
        if (instance == null) {
            instance = new HandlerManager();
            instance.handlerContainer = new HashMap<HandlerCallBackListener, SunnyHandler>();
        }
    }

    public SunnyHandler getHandler(HandlerCallBackListener handlerInterface){
        SunnyHandler handler = handlerContainer.get(handlerInterface) ;
        if(handler == null){
            handler = new SunnyHandler(handlerInterface) ;
            handlerContainer.put(handlerInterface,handler) ;
        }
        return handler ;
    }

     public void remoteHandler(HandlerCallBackListener handlerInterface){
        if(handlerContainer != null){
            handlerContainer.remove(handlerInterface) ;
        }
    }

    public void destroyHandler(){
        Iterator<HandlerCallBackListener> it = handlerContainer.keySet().iterator();
        while(it.hasNext()){
            HandlerCallBackListener hi = it.next();
            SunnyHandler rh = handlerContainer.get(hi);
            rh.removeCallbacksAndMessages(null);
        }
        handlerContainer.clear();
        handlerContainer = null;
        instance = null;
    }


    public static class SunnyHandler extends android.os.Handler {

        HandlerCallBackListener callBack ;

        public SunnyHandler(HandlerCallBackListener callBack) {
            this.callBack = callBack;
        }

        @Override
        public void handleMessage(Message msg) {
            callBack.obtainMsg(msg);
            super.handleMessage(msg);
        }
    }


}
