package com.github.demonh3x.server;

import java.util.concurrent.Executor;

public class ThreadedHandler implements ConnectionHandler {
    private final Executor executor;
    private final ConnectionHandler delegatedHandler;

    public ThreadedHandler(Executor executor, ConnectionHandler delegatedHandler) {
        this.executor = executor;
        this.delegatedHandler = delegatedHandler;
    }

    @Override
    public void handle(final Connection client) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                delegatedHandler.handle(client);
            }
        });
    }
}
