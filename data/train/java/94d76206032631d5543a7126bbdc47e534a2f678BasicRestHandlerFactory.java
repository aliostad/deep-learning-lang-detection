package com.jcrud.impl;

import java.util.HashMap;
import java.util.Map;

import com.jcrud.model.RestHandler;

public class BasicRestHandlerFactory implements RestHandlerFactory {

	private final Map<Class<?>, RestHandler> restHandlers = new HashMap<Class<?>, RestHandler>();

	private final RestHandler defaultRestHandler;

	public BasicRestHandlerFactory(RestHandler defaultRestHandler) {
		this.defaultRestHandler = defaultRestHandler;
	}

	public BasicRestHandlerFactory(RestHandler defaultRestHandler, Map<Class<?>, RestHandler> handlers) {
		this(defaultRestHandler);
		this.restHandlers.putAll(handlers);
	}

	@Override
	public RestHandler getRestHandler(Class<?> resourceClass) {

		RestHandler restHandler = restHandlers.get(resourceClass);

		if (restHandler == null) {
			restHandler = defaultRestHandler;
		}

		return restHandler;
	}
}
