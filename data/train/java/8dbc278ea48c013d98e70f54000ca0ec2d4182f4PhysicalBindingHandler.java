package org.fabric3.spi.model.physical;

import java.net.URI;

/**
 * Model class for a binding handler configuration.
 */
public class PhysicalBindingHandler {
    private URI handlerUri;

    /**
     * Constructor
     *
     * @param handlerUri the component URI of the handler
     */
    public PhysicalBindingHandler(URI handlerUri) {
        this.handlerUri = handlerUri;
    }

    /**
     * Returns the component URI of the handler.
     *
     * @return the component URI of the handler
     */
    public URI getHandlerUri() {
        return handlerUri;
    }
}
