package dproxies.util;

import org.testng.annotations.Test;

import dproxies.client.ClientHandshakeHandler;
import dproxies.client.ClientRegistrationHandler;
import dproxies.client.ObjectCallHandler;
import dproxies.handler.Handler;
import dproxies.handler.PipedHandler;
import dproxies.handler.impl.IOHandler;
import dproxies.server.DynamicProxyHandler;
import dproxies.server.ServerHandshakeHandler;
import dproxies.server.ServerRegistrationHandler;
import dproxies.tuple.Tuples;

public class HandlerChainFactoryTest {

    @Test
    public void testServerDefaultHandlerChain() throws Exception {
	HandlerChainFactory<String> factory = new HandlerChainFactory<String>(
		String.class, "");
	Handler<Tuples> handler = factory.getServerDefaultHandlerChain();
	PipedHandler<?> pipedHandler = (PipedHandler<?>) handler;
	assert pipedHandler instanceof DynamicProxyHandler<?>;
	assert pipedHandler.getPrev() instanceof ServerRegistrationHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert pipedHandler.getPrev() instanceof ServerHandshakeHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert pipedHandler.getPrev() instanceof IOHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert null == pipedHandler.getPrev();

    }

    @Test
    public void testClientDefaultHandlerChain() throws Exception {
	HandlerChainFactory<String> factory = new HandlerChainFactory<String>(
		String.class, "bar");
	Handler<Tuples> handler = factory.getClientDefaultHandlerChain("foo");
	PipedHandler<?> pipedHandler = (PipedHandler<?>) handler;
	assert pipedHandler instanceof ObjectCallHandler<?>;
	assert pipedHandler.getPrev() instanceof ClientRegistrationHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert pipedHandler.getPrev() instanceof ClientHandshakeHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert pipedHandler.getPrev() instanceof IOHandler;
	pipedHandler = (PipedHandler<?>) pipedHandler.getPrev();
	assert null == pipedHandler.getPrev();

    }

}
