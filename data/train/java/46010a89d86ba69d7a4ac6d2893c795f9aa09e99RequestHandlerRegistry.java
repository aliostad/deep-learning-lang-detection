package org.mvander3.speakEasy.action;

import java.util.Map;

import org.mvander3.speakEasy.message.RequestHandler;

public class RequestHandlerRegistry {

    private Map<String, RequestHandler<?, ?>> registry;

    public RequestHandler<?, ?> getRequestHandler(String requestHandlerRegistryKey) {
        return registry.get(requestHandlerRegistryKey);
    }

    public void registerRequestHandler(String requestHandlerRegistryKey, RequestHandler<?, ?> requestHandler) {
        this.registry.put(requestHandlerRegistryKey, requestHandler);
    }

    public void setRegistry(Map<String, RequestHandler<?, ?>> registry) {
        this.registry = registry;
    }

}
