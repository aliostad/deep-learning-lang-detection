package com.cloudpact.mowbly.log.handler;

import java.util.Enumeration;

/**
 * HandlerAttachable
 * 
 * @author Prashanth Jonnala <prashanth@cloudpact.com>
 */
public interface HandlerAttachable {

    /**
     * Attach a handler
     * 
     * @param handler The handler to be attached
     */
    public void attachHandler(Handler handler);

    /**
     * Detach a handler
     * 
     * @param handler The handler to be detached
     */
    public void detachHandler(Handler handler);

    /**
     * Detach all handlers
     */
    public void detachAllHandlers();

    /**
     * Get all the attached handlers
     * 
     * @return The enumeration of handlers attached
     */
    public Enumeration<Handler> getAttachedHandlers();

    /**
     * Get the attached handler by name
     * 
     * @param name The name of the handler
     * @return The attached handler
     */
    public Handler getAttachedHandler(String name);
}
