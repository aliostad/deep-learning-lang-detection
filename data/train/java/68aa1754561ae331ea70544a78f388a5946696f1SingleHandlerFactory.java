/**
 * Copyright (C) 2011-2014 Barchart, Inc. <http://www.barchart.com/>
 *
 * All rights reserved. Licensed under the OSI BSD License.
 *
 * http://www.opensource.org/licenses/bsd-license.php
 */
package com.barchart.netty.server.util;

import com.barchart.netty.server.HandlerFactory;


public class SingleHandlerFactory<H> implements HandlerFactory<H> {

	private final H handler;

	public SingleHandlerFactory(final H handler_) {
		handler = handler_;
	}

	@Override
	public H newHandler() {
		return handler;
	}

}