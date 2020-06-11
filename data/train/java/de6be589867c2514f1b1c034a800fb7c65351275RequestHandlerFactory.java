package hlo.webserver;

import hlo.framework.PathHandler;
import hlo.framework.RouterHandler;
import hlo.framework.StaticContentHandler;

/**
 * Created by hlo on 5/9/15.
 */
public class RequestHandlerFactory {
    static RequestHandler createHandler() {
        RouterHandler handler = new RouterHandler();
        handler.register(PathHandler.of("/slow", new SlowHandler()));

        RequestHandler contentHandler = new StaticContentHandler("./content");
        handler.register(PathHandler.of("/content", contentHandler));
        handler.register(PathHandler.of("/proxy", contentHandler));
        return handler;//DebugHandler.of(handler);
    }
}
