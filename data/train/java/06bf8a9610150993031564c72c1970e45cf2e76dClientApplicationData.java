package main;

import socketServer.ClientHandler;

public class ClientApplicationData extends ApplicationData {
	private ClientHandler handler;
	public ClientApplicationData(ClientHandler handler) {
		this(new String[0], handler);
	}
	public ClientApplicationData(String[] users, ClientHandler handler){
		super();
		this.handler = handler;
	}
	public void connectUserToClient(User user){
		user.setSocket(handler.getSocket());
		handler.setUser(user);
	}
	public void disconnectUserFromClient(){
		handler.setUser(null);
	}
}