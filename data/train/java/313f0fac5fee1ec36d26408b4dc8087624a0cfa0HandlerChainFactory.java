package dproxies.util;

import dproxies.client.ClientHandshakeHandler;
import dproxies.client.ClientRegistrationHandler;
import dproxies.client.ObjectCallHandler;
import dproxies.handler.Handler;
import dproxies.handler.impl.IOHandler;
import dproxies.server.DynamicProxyHandler;
import dproxies.server.ServerHandshakeHandler;
import dproxies.server.ServerRegistrationHandler;
import dproxies.tuple.Tuples;

public class HandlerChainFactory<T> {

    private final Class<T> _interfaceClass;
    private final T _delegate;

    public HandlerChainFactory(Class<T> interfaceClass, T delegate) {
	_interfaceClass = interfaceClass;
	_delegate = delegate;
    }

    public Handler<Tuples> getServerDefaultHandlerChain() {
	Handler<Tuples> handler = new IOHandler();
	handler = new ServerHandshakeHandler(handler, new Generator());
	handler = new ServerRegistrationHandler(handler,
		new ClientRegistration());
	handler = new DynamicProxyHandler<T>(handler, _interfaceClass);
	return handler;
    }

    public Handler<Tuples> getClientDefaultHandlerChain(String clientName) {
	Handler<Tuples> handler = new IOHandler();
	handler = new ClientHandshakeHandler(handler, new Generator());
	handler = new ClientRegistrationHandler(handler, clientName);
	handler = new ObjectCallHandler<T>(handler, _delegate);
	return handler;
    }

}
