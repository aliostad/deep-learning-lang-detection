package com.aespen.stickynotes.test;

import android.test.AndroidTestCase;

import com.aespen.stickynotes.core.ServiceLocator;

public class ServiceLocatorTests extends AndroidTestCase 
{
	// Test Interface
	private interface ITestService { }
	
	// Test Service
	private class TestService implements ITestService { }
	
    protected void setUp() throws Exception
    {
    	ServiceLocator.clearServices();
        super.setUp();
    }
    
    protected void tearDown() throws Exception
    {
    	ServiceLocator.clearServices();
        super.tearDown();
    }
    
    // This test affects our tearDown, so run it first
    public void testClearServices() throws Exception
    {
    	// Act
    	TestService testService = new TestService();
    	
        // Arrange
        ServiceLocator.registerService(testService);
        ServiceLocator.clearServices();
        TestService retreivedService = ServiceLocator.getService(TestService.class);
        
        // Assert
        assertNull(retreivedService);
    }

    public void testRegisterService() throws Exception
    {
    	// Act
    	TestService testService = new TestService();
    	
        // Arrange
        ServiceLocator.registerService(testService);
        TestService retreivedService = ServiceLocator.getService(TestService.class);
        
        // Assert
        assertNotNull(retreivedService);
    }

    public void testRegisterSameServiceThrowsException()
    {
    	// Act
    	TestService testServiceOne = new TestService();
    	TestService testServiceTwo = new TestService();
    	
    	try
    	{
    		// Arrange
            ServiceLocator.registerService(testServiceOne);
            ServiceLocator.registerService(testServiceTwo);
            
            // Assert (should have thrown an exception)
            fail();
		}
    	catch (Exception e) { }
    }
    
    public void testRegisterServiceWithInterface() throws Exception
    {
    	// Act
    	TestService testService = new TestService();
    	
    	// Arrange
    	ServiceLocator.registerService(ITestService.class, testService);
    	ITestService retreivedTestService = ServiceLocator.getService(ITestService.class);
    	
    	// Assert
    	assertNotNull(retreivedTestService);
    }
}
