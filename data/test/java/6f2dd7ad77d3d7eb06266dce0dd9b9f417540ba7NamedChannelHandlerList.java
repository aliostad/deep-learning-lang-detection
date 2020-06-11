package de.uniluebeck.itm.nettyprotocols;

import org.jboss.netty.channel.ChannelHandler;

import java.util.Collection;
import java.util.LinkedList;

public class NamedChannelHandlerList extends LinkedList<NamedChannelHandler> {

	public NamedChannelHandlerList() {
	}

	public NamedChannelHandlerList(final Collection<? extends NamedChannelHandler> c) {
		super(c);
	}

	public NamedChannelHandlerList(final NamedChannelHandlerList... lists) {
		for (NamedChannelHandlerList list : lists) {
			addAll(list);
		}
	}

	public NamedChannelHandlerList(final Iterable<? extends NamedChannelHandler> handlers) {
		for (NamedChannelHandler handler : handlers) {
			add(handler);
		}
	}

	public NamedChannelHandlerList(final NamedChannelHandler handler, final NamedChannelHandler... moreHandlers) {
		add(handler);
		for (NamedChannelHandler anotherHandler : moreHandlers) {
			add(anotherHandler);
		}
	}

	public boolean add(final String name, final ChannelHandler channelHandler) {
		return add(new NamedChannelHandler(name, channelHandler));
	}

	public void add(NamedChannelHandlerList namedChannelHandlers) {
		addAll(namedChannelHandlers);
	}
}
