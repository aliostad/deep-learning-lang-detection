package com.redcreen.rpcplus.handler;

import com.redcreen.rpcplus.channel.Channel;
import com.redcreen.rpcplus.channel.ChannelException;
import com.redcreen.rpcplus.channel.ChannelHandler;
import com.redcreen.rpcplus.channel.ChannelHandlerWrapper;
import com.redcreen.rpcplus.support.URL;

public abstract class AbstractHandlerWrapper implements ChannelHandler ,ChannelHandlerWrapper{
    
    protected ChannelHandler handler ;
    
    public AbstractHandlerWrapper(URL url, ChannelHandler handler) {
        super();
        this.handler = handler;
    }

    @Override
    public void connected(Channel channel) throws ChannelException {
        handler.connected(channel);
    }

    @Override
    public void disconnected(Channel channel) throws ChannelException {
        handler.disconnected(channel);
    }

    @Override
    public void sent(Channel channel, Object message) throws ChannelException {
        handler.sent(channel, message);
    }

    @Override
    public void received(Channel channel, Object message) throws ChannelException {
        handler.received(channel, message);
    }

    @Override
    public void caught(Channel channel, Throwable exception) throws ChannelException {
        handler.caught(channel, exception);
    }

    @Override
    public ChannelHandler getHandler() {
        if (handler instanceof ChannelHandlerWrapper){
            return ((ChannelHandlerWrapper)handler).getHandler();
        } else {
            return handler;
        }
    }
}
