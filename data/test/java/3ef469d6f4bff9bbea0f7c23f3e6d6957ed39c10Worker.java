package com.mu.director.worker;

import com.mu.director.worker.handler.Handler;

import java.awt.*;
import java.util.HashSet;
import java.util.Set;

public class Worker {

    private Set<Handler> handlers = new HashSet<Handler>();
    private Handler handler;

    public void submit(final Handler handler) {
        handlers.add(handler);
    }

    public void revoke(final Handler handler) {
        handlers.remove(handler);
    }

    public Handler getCurrent() {
        for(final Handler handler : handlers) {
            if(handler.active())
                return handler;
        }
        return null;
    }

    public int process() {
        final Handler handler = getCurrent();
        if(handler != null) {
            return handler.loop();
        }
        return 0;
    }

    public void onRepaint(Graphics g) {
        final Handler current = getCurrent();
        if(current != null)
            current.onRepaint(g);
    }

}
