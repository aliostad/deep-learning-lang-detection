package com.niuhp.corejava.pattern.responsibilitychain;

import org.junit.Test;

public class ResponsibilityChainTest {

	@Test
	public void testResponsibilityChain() {
		Request r1 = new Request("create");
		Request r2 = new Request("delete");
		Request r3 = new Request("modify");
		Request r4 = new Request("query");

		Handler endHandler = new ConcreteHandler("print");
		Handler h1 = new ConcreteHandler(endHandler, "create");
		Handler h2 = new ConcreteHandler(h1, "delete");
		Handler h3 = new ConcreteHandler(h2, "modify");
		Handler startHandler = new ConcreteHandler(h3, "findAll");
		
		startHandler.handleRequest(r1);
		startHandler.handleRequest(r2);
		startHandler.handleRequest(r3);
		startHandler.handleRequest(r4);
		
		// startHandler.handleRequest(r3);
	}
}
