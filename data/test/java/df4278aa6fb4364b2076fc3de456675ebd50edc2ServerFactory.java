package org.hoydaa.restmock.server;

import org.hoydaa.restmock.server.manager.ManagerHandler;
import org.hoydaa.restmock.server.manager.RequestRepository;
import org.hoydaa.restmock.server.manager.RequestRepositoryImpl;
import org.hoydaa.restmock.server.manager.RestMockHandler;
import org.mortbay.jetty.Server;

/**
 * @author Umut Utkan
 */
public class ServerFactory {

    public static void createServer(int port) throws Exception {
        RequestRepository requestRepository = new RequestRepositoryImpl();
        ManagerHandler managerHandler = new ManagerHandler();
        managerHandler.setRequestRepository(requestRepository);
        org.hoydaa.restmock.server.manager.MockHandler mockHandler = new org.hoydaa.restmock.server.manager.MockHandler();
        mockHandler.setRequestRepository(requestRepository);
        RestMockHandler restMockHandler = new RestMockHandler();
        restMockHandler.setManagerHandler(managerHandler);
        restMockHandler.setMockHandler(mockHandler);

        MockHandler mainHandler = new MockHandler();
        mainHandler.putRequestHandler(".*", restMockHandler);

        Server server = new Server(port);
        server.setHandler(mainHandler);
        server.start();
    }

}
