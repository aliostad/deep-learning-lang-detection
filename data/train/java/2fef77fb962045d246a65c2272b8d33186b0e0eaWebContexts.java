/**
 * 
 */
package com.andrewregan.kodomondo.jetty;

import javax.inject.Inject;
import javax.inject.Singleton;

import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;

/**
 * @Singleton wrapper for ContextHandlerCollection so we can share across DS configs
 *
 * @author andrewregan
 *
 */
@Singleton
public class WebContexts {

	private ContextHandlerCollection handlerColl = new ContextHandlerCollection();

	@Inject WebContexts() {
		// NOOP
	}

	public void addContext( String prefix, Handler handler) {
		final ContextHandler listingsCtxt = new ContextHandler(prefix);
		listingsCtxt.setHandler(handler);
		handlerColl.addHandler(listingsCtxt);
	}

	public Handler getHandler() {
		return handlerColl;
	}
}