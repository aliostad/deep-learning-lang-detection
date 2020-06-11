package vedio.handler;

import peersim.util.ExtendedRandom;
import vedio.protocol.Dispatcher;

/**
 * Created by Jaric Liao on 2015/11/1.
 */
public class HandlerFactory {

    public static Handler createHandler(String messageType){
        Handler handler = null;
        try{
            Class className = Class.forName("vedio.handler."+ Dispatcher.mode+messageType+"Handler");
            handler = (Handler) className.newInstance();
        } catch ( Exception e){
            e.printStackTrace();
        }
        return handler;
    }
}
