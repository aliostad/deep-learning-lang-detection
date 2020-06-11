/**
 * 
 */
package tests;

import static org.junit.Assert.*;

import code.*;
import org.junit.Test;

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
		Handler headHandler;
		
		ChainFactory classUnderTest = new ChainFactory();
		
		classUnderTest.registerHandler(firstHandler);
		classUnderTest.registerHandler(secondHandler);
		
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
    public void test3() {
        Request request = new Request("Car","9","108");

        Handler firstHandler = new THandler();
        // Handler secondHandler = new JHandler();
        Handler headHandler;

        ChainFactory classUnderTest = new ChainFactory();

        classUnderTest.registerHandler(firstHandler);
        //classUnderTest.registerHandler(secondHandler);

        headHandler= classUnderTest.getChain();



        Boolean actualOutput = headHandler.handleRequest(request);

        assertTrue("Handler failed to grab",actualOutput);
    }
}
