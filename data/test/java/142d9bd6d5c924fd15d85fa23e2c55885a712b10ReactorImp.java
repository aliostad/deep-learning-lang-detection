package com.zim.posapatterns.pattern.concurrent.eventhandler.reactor;

import java.util.List;
import java.util.Map;

/**
 * Developed by martin.zangl@globant.com
 */
public class ReactorImp implements Reactor {

    Map<Handler, EventHandler> handlers;

    @Override
    public void handleEvents() {
        while(true){
            // ...
            for(Handler handler: handlers.keySet()){
                EventHandler eventHandler = handlers.get(handler);
                eventHandler.handleEvent(handler);
            }
        }
    }

    @Override
    public void registerHandler(EventHandler eventHandler) {
        Handler handler = eventHandler.getHandler();
        handlers.put(handler,eventHandler);
        //
    }

    @Override
    public void unregisterHandler(EventHandler eventHandler) {
        handlers.remove(eventHandler);
    }
}
