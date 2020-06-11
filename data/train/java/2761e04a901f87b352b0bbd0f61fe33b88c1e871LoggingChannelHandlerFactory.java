package framework.channels.logging;

import framework.channels.IChannelHandler;
import framework.channels.IChannelHandlerFactory;

public class LoggingChannelHandlerFactory<TRequest, TResponse> implements IChannelHandlerFactory<TRequest, TResponse>
{
	// dependency
	private final IChannelHandlerFactory<TRequest, TResponse> underlyingChannelHandlerFactory;

	public LoggingChannelHandlerFactory(IChannelHandlerFactory<TRequest, TResponse> underlyingChannelHandlerFactory)
	{
		// inject dependency
		if (underlyingChannelHandlerFactory == null)
		{
			throw new NullPointerException("underlyingChannelHandlerFactory is null");
		}

		this.underlyingChannelHandlerFactory = underlyingChannelHandlerFactory;
	}
	
	@Override
	public IChannelHandler<TRequest, TResponse> createChannelHandler()
	{
		return new LoggingChannelHandler<TRequest, TResponse>(this.underlyingChannelHandlerFactory.createChannelHandler());
	}
}
