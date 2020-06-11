package psn.lotus.server.handler;

import org.springframework.util.Assert;
import psn.lotus.server.api.Handler;
import psn.lotus.server.api.HandlerContainer;

import java.util.concurrent.ConcurrentLinkedDeque;

/**
 * 同步处理器容器
 *
 * @author: nicee
 * @since: 2016/1/14
 */
public class ConcurrentHandlerContainer implements HandlerContainer {

    private final ConcurrentLinkedDeque<Handler> handlers = new ConcurrentLinkedDeque<Handler>();

    public ConcurrentHandlerContainer() {

    }

    public Handler[] getHandlers() {
        Handler[] arrHandler = new Handler[handlers.size()];
        return handlers.toArray(arrHandler);
    }

    public void setHandlers(Handler[] handlers) {
        Assert.notNull(handlers, "handlers could not be null.");
        for (Handler handler : handlers) {
            this.handlers.add(handler);
        }
    }

    public void addHandler(Handler handler) {
        Assert.notNull(handler, "handlers could not be null.");
        handlers.add(handler);
    }

    public void removeHandler(Handler handler) {
        Assert.notNull(handler, "handlers could not be null.");
        handlers.remove(handler);
    }

}
