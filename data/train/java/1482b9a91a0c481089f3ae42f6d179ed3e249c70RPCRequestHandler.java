package com.asksunny.rpc.server;

import io.netty.channel.ChannelHandlerContext;

import java.io.IOException;

import com.asksunny.protocol.rpc.ProtocolDecodeHandler;
import com.asksunny.protocol.rpc.RPCEnvelope;

public class RPCRequestHandler implements ProtocolDecodeHandler{

	
	ChannelHandlerContext channelHandlerContext;
	
	
	
	public RPCRequestHandler(ChannelHandlerContext channelHandlerContext) {
		super();
		this.channelHandlerContext = channelHandlerContext;
	}

	public ChannelHandlerContext getChannelHandlerContext() {
		return channelHandlerContext;
	}

	public void setChannelHandlerContext(ChannelHandlerContext channelHandlerContext) {
		this.channelHandlerContext = channelHandlerContext;
	}

	@Override
	public void onSocketIOError(IOException iex) {
				
	}

	@Override
	public void onReceive(RPCEnvelope envelope) 
	{
		
		
	}

}
