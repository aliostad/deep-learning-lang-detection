package com.ericsson.nms.behavioural.chainofresp.impl;

public abstract class Handler {
    protected Handler nextHandler = null;

    public Handler(){
    }

    public Handler(Handler nextHandler){
        this.nextHandler = nextHandler;
    }

    public void setNextHandler(final Handler nextHandler){
        this.nextHandler = nextHandler;
    }

    /**
     * Chance to handle the object. The handler should then pass the object to the nextHandler, if one exists.
     * @param someObject the object to be processed
     */
    public void handleRequest(final Object someObject){
        passToNext(someObject);
    }

    protected void passToNext(final Object someObject){
        //if there is no other handler, stop and return.
        if(nextHandler==null){
            return;
        }
        nextHandler.handleRequest(someObject);
    }
}
