package com.partsoft.umsp.handler;

import java.io.IOException;

import com.partsoft.umsp.Handler;
import com.partsoft.umsp.HandlerContainer;
import com.partsoft.umsp.OriginHandler;
import com.partsoft.umsp.Request;
import com.partsoft.umsp.Response;

public class HandlerWrapper extends AbstractHandlerContainer {

	private Handler _handler;

	public HandlerWrapper() {
		super();
	}
	
	public HandlerWrapper(Handler handler) {
		super();
		setHandler(handler);
	}

	public Handler getHandler() {
		return _handler;
	}

	public void setHandler(Handler handler) {
		try {
			Handler old_handler = _handler;

			if (getOrigin() != null)
				getOrigin().getContainer().update(this, old_handler, handler, "handler");

			if (handler != null) {
				handler.setOrigin(getOrigin());
			}

			_handler = handler;

			if (old_handler != null) {
				if (old_handler.isStarted())
					old_handler.stop();
			}
		} catch (Exception e) {
			IllegalStateException ise = new IllegalStateException();
			ise.initCause(e);
			throw ise;
		}
	}

	public void addHandler(Handler handler) {
		Handler old = getHandler();
		if (old != null && !(handler instanceof HandlerContainer))
			throw new IllegalArgumentException("Cannot add");
		setHandler(handler);
		if (old != null)
			((HandlerContainer) handler).addHandler(old);
	}

	public void removeHandler(Handler handler) {
		Handler old = getHandler();
		if (old != null && (old instanceof HandlerContainer))
			((HandlerContainer) old).removeHandler(handler);
		else if (old != null && handler.equals(old))
			setHandler(null);
		else
			throw new IllegalStateException("Cannot remove");
	}

	protected void doStart() throws Exception {
		if (_handler != null)
			_handler.start();
		super.doStart();
	}

	protected void doStop() throws Exception {
		super.doStop();
		if (_handler != null)
			_handler.stop();
	}

	public void handle(String protocol, Request request, Response response, int dispatch) throws IOException {
		if (_handler != null && isStarted())
			_handler.handle(protocol, request, response, dispatch);
	}

	public void setOrigin(OriginHandler server) {
		OriginHandler old_server = getOrigin();

		super.setOrigin(server);

		Handler h = getHandler();
		if (h != null)
			h.setOrigin(server);

		if (server != null && server != old_server)
			server.getContainer().update(this, null, _handler, "handler");
	}

	protected Object expandChildren(Object list, Class<?> byClass) {
		return expandHandler(_handler, list, byClass);
	}

}
