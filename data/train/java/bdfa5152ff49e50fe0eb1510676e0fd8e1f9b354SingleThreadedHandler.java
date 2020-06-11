package hlo.webserver;

import java.io.IOException;
import java.net.Socket;

/**
 * Created by hlo on 5/10/15.
 */
public class SingleThreadedHandler implements ConnectionHandler {

    private final RequestHandler requestHandler;

    SingleThreadedHandler(RequestHandler requestHandler) {
        this.requestHandler = requestHandler;
    }

    @Override
    public void handle(Socket socket) {
        try {
            SocketHandler.handle(socket, requestHandler);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
