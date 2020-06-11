package server;

import handler.ExceptionHandler;
import handler.Handler;
import handler.PrintingHandler;
import handler.TransmogrifyHandler;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

public class SingleThreadedBlockingServer {
    public static void main(String[] args) throws IOException {
        ServerSocket ss = new ServerSocket(8080);
        while (true) {
            Socket socket = ss.accept();
            Handler<Socket, IOException> handler = new ExceptionHandler<>(new PrintingHandler(new TransmogrifyHandler()));
            handler.handle(socket);
            socket.close();
        }
    }
}
