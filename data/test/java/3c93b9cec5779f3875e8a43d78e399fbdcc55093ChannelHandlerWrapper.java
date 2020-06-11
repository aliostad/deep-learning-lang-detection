package com.renren.rsa.transport;

public class ChannelHandlerWrapper implements ChannelHandler{

	private ChannelHandler handler;
	
	public ChannelHandlerWrapper(ChannelHandler handler){
		this.handler = handler;
	}
	
	public ChannelHandler getChannelHandler(){
		return this.handler;
	}
	
	@Override
	public void connected(Channel channel) {
		handler.connected(channel);
	}

	@Override
	public void disconnected(Channel channel) {
		handler.disconnected(channel);
	}

	@Override
	public void sent(Channel channel, Object message) {
		handler.sent(channel, message);
	}

	@Override
	public void received(Channel channel, Object message) {
		handler.received(channel, message);
	}

	@Override
	public void caught(Channel channel, Throwable exception) {
		handler.caught(channel, exception);
	}

}
