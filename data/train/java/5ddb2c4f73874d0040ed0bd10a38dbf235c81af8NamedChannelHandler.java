package bma.common.netty.handler;

import org.jboss.netty.channel.ChannelHandler;

public class NamedChannelHandler {

	private String name;
	private ChannelHandler handler;

	public NamedChannelHandler() {
		super();
	}

	public NamedChannelHandler(String name, ChannelHandler handler) {
		super();
		this.name = name;
		this.handler = handler;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ChannelHandler getHandler() {
		return handler;
	}

	public void setHandler(ChannelHandler handler) {
		this.handler = handler;
	}

}
