/**
 * Copyright (C) 2011-2013 Barchart, Inc. <http://www.barchart.com/>
 *
 * All rights reserved. Licensed under the OSI BSD License.
 *
 * http://www.opensource.org/licenses/bsd-license.php
 */
package com.barchart.http.request;

/**
 * Convenience tuple for returning the results of a RequestHandler / path prefix
 * lookup.
 */
public class RequestHandlerMapping {

	private final String path;
	private final RequestHandler handler;
	private final RequestHandlerFactory factory;

	public RequestHandlerMapping(final String path_,
			final RequestHandler handler_) {
		path = path_;
		handler = handler_;
		factory = null;
	}

	public RequestHandlerMapping(final String path_,
			final RequestHandlerFactory factory_) {
		path = path_;
		handler = null;
		factory = factory_;
	}

	public String path() {
		return path;
	}

	public RequestHandler handler(final ServerRequest request) {

		if (handler != null) {
			return handler;
		}

		return factory.newHandler(request);

	}

	public static RequestHandlerMapping create(final String path_,
			final Object handler_) {

		if (handler_ instanceof RequestHandler) {
			return new RequestHandlerMapping(path_, (RequestHandler) handler_);
		}

		return new RequestHandlerMapping(path_,
				(RequestHandlerFactory) handler_);

	}

}
