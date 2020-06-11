import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerCollection;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.webapp.WebAppContext;

public class DinoServer {
    private final Server server;

    public DinoServer() {
        server = new Server(8080);
        server.setHandler(handlers());
    }

    private void start() throws Exception {
        server.start();
        server.join();
    }

    private Handler handlers() {
        HandlerList handlerList = new HandlerList();
        handlerList.setHandlers(new Handler[]{webAppHandler()});

        HandlerCollection handlerCollection = new HandlerCollection();
        handlerCollection.addHandler(handlerList);

        return handlerCollection;
    }

    private Handler webAppHandler() {
        WebAppContext handler = new WebAppContext();
        handler.setWar("src/main/webapp");

        return handler;
    }

    public static void main(String... args) throws Exception {
        Migrations.migrate();
        System.out.println("DB Migrated");

        new DinoServer().start();
    }
}
