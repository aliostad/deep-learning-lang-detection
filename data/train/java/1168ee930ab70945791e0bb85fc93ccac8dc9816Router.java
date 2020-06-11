import java.util.ArrayList;
import java.util.List;

public class Router {
    private final List<Handler> handlers;
    private final Handler notFoundHandler;

    public Router() {
        handlers = new ArrayList<>();
        notFoundHandler = new NotFoundHandler();
    }

    public Handler findHandler(String path) {
        for(Handler handler : handlers) {
            if(handler.canHandle(path)) {
                return handler;
            }
        }
        return notFoundHandler;
    }

    public void add(Handler handler) {
        handlers.add(handler);
    }
}
