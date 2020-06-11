package tests.mocks;

import bent.server.IHandlerFactory;
import bent.server.sockets.ISocket;

public class MockHandlerFactory implements IHandlerFactory {
    public int makeHandlerCount;
    public MockRequestHandler createdHandler;
    public ISocket makeHandlerArgument;

    public MockHandlerFactory() {
        makeHandlerCount = 0;
        createdHandler = new MockRequestHandler();
    }

    public MockRequestHandler makeHandler(ISocket socket) {
        makeHandlerArgument = socket;
        makeHandlerCount++;
        return createdHandler;
    }
}
