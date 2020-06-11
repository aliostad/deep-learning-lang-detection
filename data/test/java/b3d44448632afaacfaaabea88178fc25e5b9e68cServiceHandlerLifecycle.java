package com.plexobject.service;

import com.plexobject.handler.RequestHandler;

public class ServiceHandlerLifecycle implements ServiceHandlerLifecycleMBean {
    private final ServiceRegistry registry;
    private final RequestHandler handler;

    public ServiceHandlerLifecycle(final ServiceRegistry registry,
            final RequestHandler handler) {
        this.registry = registry;
        this.handler = handler;
    }

    @Override
    public void start() {
        registry.addRequestHandler(handler);
    }

    @Override
    public void stop() {
        registry.removeRequestHandler(handler);
    }

    @Override
    public boolean isRunning() {
        return registry.existsRequestHandler(handler);
    }

    @Override
    public String ping() {
        if (handler instanceof Pingable) {
            return ((Pingable) handler).ping();
        }
        return getSummary();
    }

    @Override
    public String getSummary() {
        return registry.getServiceMetricsRegistry().getServiceMetrics(handler)
                .getSummary();
    }
}
