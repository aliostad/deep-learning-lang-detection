package de.mtws.connection.imp;

import de.mtws.connection.api.HandlerAdapter;
import de.mtws.connection.api.HandlerInjector;

public class StreamHandlerInjector implements HandlerInjector {

	private final Class<? extends HandlerAdapter> handler;

	public StreamHandlerInjector(Class<? extends HandlerAdapter> handler) {
		this.handler = handler;
	}

	@Override
	public HandlerAdapter inject() {
		try {
			return handler.newInstance();
		} catch (InstantiationException | IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

}
