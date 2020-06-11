package net.customware.gwt.dispatch.server;

/**
 * This is a subclass of {@link ActionHandlerRegistry} which allows registration
 * of handlers by passing in the handler instance directly.
 * 
 * @author David Peterson
 */
public interface InstanceActionHandlerRegistry extends ActionHandlerRegistry {
    /**
     * Adds the specified handler instance to the registry.
     * 
     * @param handler
     *            The action handler.
     */
    public void addHandler( ActionHandler<?, ?> handler );

    /**
     * Removes the specified handler.
     * 
     * @param handler
     *            The handler.
     * @return <code>true</code> if the handler was previously registered and
     *         was successfully removed.
     */
    boolean removeHandler( ActionHandler<?, ?> handler );
}
