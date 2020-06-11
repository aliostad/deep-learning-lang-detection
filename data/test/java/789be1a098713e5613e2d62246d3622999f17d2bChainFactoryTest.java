/**
 * 
 */
package tests;

import static org.junit.Assert.*;

import org.junit.Test;

import code.ChainFactory;
import code.Handler;
import code.JHandler;
import code.OHandler;
import code.Request;
import code.TomHandler;

/**
 * @author oded
 *
 */
public class ChainFactoryTest {

	@Test
	public void test() {
		Request request = new Request("Jack","7","8");
		
		Handler firstHandler = new OHandler();
		Handler secondHandler = new JHandler();
		Handler thirdHandler = new TomHandler();
		Handler headHandler;
		
		ChainFactory classUnderTest = new ChainFactory();
		
		classUnderTest.registerHandler(firstHandler);
		classUnderTest.registerHandler(secondHandler);
		classUnderTest.registerHandler(thirdHandler);
		
		headHandler= classUnderTest.getChain();
				
				
		
		Boolean actualOutput = headHandler.handleRequest(request);
		
		assertTrue("Handler failed to grab",actualOutput);
	}

	@Test
	public void test2() {
		Request request = new Request("Oded","9","108");
		
		Handler firstHandler = new OHandler();
		// Handler secondHandler = new JHandler();
		Handler headHandler;
		
		ChainFactory classUnderTest = new ChainFactory();
		
		classUnderTest.registerHandler(firstHandler);
		//classUnderTest.registerHandler(secondHandler);
		
		headHandler= classUnderTest.getChain();
				
				
		
		Boolean actualOutput = headHandler.handleRequest(request);
		
		assertTrue("Handler failed to grab",actualOutput);
	}

	@Test
	public void test3_tom() {
		Request request = new Request("TomHedges","6","7");
		
		Handler firstHandler = new TomHandler();
		Handler headHandler;
		
		ChainFactory classUnderTest = new ChainFactory();
		
		classUnderTest.registerHandler(firstHandler);
		
		headHandler= classUnderTest.getChain();
		
		Boolean actualOutput = headHandler.handleRequest(request);
		
		assertTrue("Handler failed to grab",actualOutput);
	}

	@Test
	public void test4_oded() {
		Request request = new Request("TomHedges","9","10");
		
		Handler firstHandler = new OHandler();
		Handler secondHandler = new JHandler();
		Handler thirdHandler = new TomHandler();
		Handler headHandler;
		
		ChainFactory classUnderTest = new ChainFactory();
		
		classUnderTest.registerHandler(firstHandler);
		classUnderTest.registerHandler(secondHandler);
		classUnderTest.registerHandler(thirdHandler);
		
		headHandler= classUnderTest.getChain();
				
				
		
		Boolean actualOutput = headHandler.handleRequest(request);
		
		assertTrue("Handler failed to grab",actualOutput);
	}

	
}
