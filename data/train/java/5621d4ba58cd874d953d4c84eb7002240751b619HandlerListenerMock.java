package net.codjo.mad.server.handler;
import net.codjo.test.common.LogString;

public class HandlerListenerMock implements HandlerListener {
    private LogString log;


    public HandlerListenerMock() {
        this(new LogString());
    }


    public HandlerListenerMock(LogString log) {
        this.log = log;
    }


    public void handlerStarted(Handler handler, HandlerContext handlerContext) {
        log.call("handlerStarted", handler.getId());
    }


    public void handlerStopped(Handler handler, HandlerContext handlerContext) {
        log.call("handlerStopped", handler.getId());
    }
}
