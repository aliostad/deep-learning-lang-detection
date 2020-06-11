package searchlog;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlet.ServletHandler;
import org.eclipse.jetty.servlets.gzip.GzipHandler;

import searchlog.servlets.SearchServlet;

public class Main {

    public static void main(String[] args) throws Exception {
        Server server = new Server(8080);

        ResourceHandler resource_handler = new ResourceHandler();
        resource_handler.setDirectoriesListed(true);
        resource_handler.setWelcomeFiles(new String[]{ "index.html" });
        resource_handler.setResourceBase("html");
        
        ServletHandler servletHandler = new ServletHandler();
        server.setHandler(servletHandler);
        servletHandler.addServletWithMapping(SearchServlet.class, "/search");
        
        GzipHandler gzip = new GzipHandler();
        server.setHandler(gzip);
        HandlerList handlers = new HandlerList();
        handlers.setHandlers(new Handler[] { resource_handler, servletHandler });
        gzip.setHandler(handlers);
        
        server.start();
        server.join();
    }

}
