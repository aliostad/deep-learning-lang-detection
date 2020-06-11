package server;

import handler.Handler;
import handler.PrintingHandler;
import handler.ThreadedHandler;
import handler.TransmogrifyHandler;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class MultiThreadedBlockingServer {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(8080);
        Handler<Socket, IOException> handler = new ThreadedHandler<>(new PrintingHandler(new TransmogrifyHandler()));
        while (true) {
            Socket socket = ss.accept();
            handler.handle(socket);
        }
    }
}
