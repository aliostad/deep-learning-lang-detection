package server;

import server.handler.CustomHandler;
import server.handler.HelloHandler;
import server.handler.RedirectHandler;
import server.handler.StatisticHandler;

public enum URL_ADDRESS {
    HELLO("/hello", new HelloHandler()),
    STATUS("/status", StatisticHandler.getInstance()),
    REDIRECT("/redirect", new RedirectHandler())
    ;

    private String name;
    private CustomHandler handler;

    private URL_ADDRESS(String s, CustomHandler handler) {
        this.name =s;
        this.handler = handler;
    }

    public String getName() {
        return name;
    }

    public CustomHandler getHandler() {
        return handler;
    }

    public static URL_ADDRESS getByUrl(String url) {
        for (URL_ADDRESS item : values()) {
            if (item.getName().equals(url)){
                return item;
            }
        }
        return url.startsWith("/redirect") ? REDIRECT : null;
    }
}
