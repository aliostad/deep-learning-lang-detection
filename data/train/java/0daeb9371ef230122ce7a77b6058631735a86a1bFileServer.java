package j2ee.server.jetty;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;

public class FileServer {
	public static void main(String[] args) throws Exception {
		Server server = new Server(80);

		ResourceHandler resourceHandler = new ResourceHandler();
		resourceHandler.setDirectoriesListed(true);
		resourceHandler.setResourceBase("D:/Server/java");
		resourceHandler.setStylesheet("");
		
		HandlerList handlers = new HandlerList();
		handlers.setHandlers(new Handler[] { resourceHandler, new DefaultHandler() });
		server.setHandler(handlers);

		server.start();
		server.join();
	}
}