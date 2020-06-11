package org.mylife.home.net.hub.irc.tasks;

import org.mylife.home.net.hub.irc.IrcConnectHandler;

public class ConnectTask extends WaitableTask {

	public interface Handler {
		void executeNewConnection(String address, int port, IrcConnectHandler connectHandler);
	}
	
	private final String address;
	private final int port;
	private final IrcConnectHandler connectHandler;
	private final Handler internalHandler;
	
	public ConnectTask(String address, int port, IrcConnectHandler connectHandler, Handler internalHandler) {
		this.address = address;
		this.port = port;
		this.connectHandler = connectHandler;
		this.internalHandler = internalHandler;
	}
	
	@Override
	public void runTask() {
		internalHandler.executeNewConnection(address, port, connectHandler);
	}

}
