package resourseHandler;

import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ResourceHandler;

/**
 * Created by andreykazakov on 30.03.16.
 */
public class ResourseMain {
    public static void main(String[] args) throws Exception {

        Server server = new Server(8080);

        //1.Creating the resource handler
        ResourceHandler resourceHandler= new ResourceHandler();

        //2.Setting Resource Base
        resourceHandler.setResourceBase("folder");

        //3.Enabling Directory Listing
        resourceHandler.setDirectoriesListed(true);

        //4.Setting Context Source
        ContextHandler contextHandler= new ContextHandler("/jcg");

        //5.Attaching Handlers
        contextHandler.setHandler(resourceHandler);
        server.setHandler(contextHandler);

        // Starting the Server

        server.start();
        System.out.println("Started!");
        server.join();
    }


}
