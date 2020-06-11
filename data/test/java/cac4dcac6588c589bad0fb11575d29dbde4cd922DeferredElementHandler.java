package ru.spb.petrk.scenerenderer.parser;

/**
 *
 * @author PetrK
 */
public final class DeferredElementHandler<T> implements ElementHandler<T> {
    
    private final ElementHandler<T> handler;
    
    
    public DeferredElementHandler(ElementHandler<T> handler) {
        this.handler = handler;
    }
    
    public void launchFinish() {
        handler.finish();
    }
    
    /*
    ***********************************************************
    * Delegated / Overrided methods
    ***********************************************************
    */

    @Override
    public ElementHandler getHandler(String name) {
        return handler.getHandler(name);
    }
    
    @Override
    public void start() {
        handler.start();
    }

    @Override
    public void body(String body) {
        handler.body(body);
    }

    @Override
    public void finish() {
        // do nothing (deferred builder must be "finished" manually later)
    }
    
}
