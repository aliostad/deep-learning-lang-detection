package logging;

import logging.Log;
import logging.handler.LogHandler;
import org.junit.After;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.easymock.EasyMock.*;

public class LoggerTest{

	private static LogHandler errorHandler;
	private static LogHandler infoHandler;
	private static LogHandler debugHandler;
	private static LogHandler warningHandler;

	
	@BeforeClass
	public static void setUp() 
	{
		errorHandler = createMock(LogHandler.class);
		warningHandler = createMock(LogHandler.class);
		infoHandler = createMock(LogHandler.class);
		debugHandler = createMock(LogHandler.class);
		Log.addHandler(errorHandler);
		Log.addHandler(warningHandler);
		//Log.addHandler(infoHandler);
		//Log.addHandler(debugHandler);
	}
	
	@After
	public void tearDown() 
	{
		reset(errorHandler);
		reset(warningHandler);
		reset(infoHandler);
		reset(debugHandler);
	}
	
	@Test
	public void testAllHandlersNeedToBeCalled()
	{
		Log.setLevel(Log.DEBUG);
		expect(errorHandler.getLevel()).andReturn(Log.ERROR);
		errorHandler.write("Error", Log.ERROR);
		expect(warningHandler.getLevel()).andReturn(Log.WARNING);
		warningHandler.write("Error", Log.ERROR);
		//expect(infoHandler.getLevel()).andReturn(Log.INFO);
		//infoHandler.write("Error", Log.ERROR);
		//expect(debugHandler.getLevel()).andReturn(Log.DEBUG);
		//debugHandler.write("Error", Log.ERROR);
		replay(errorHandler);
		replay(warningHandler);
		//replay(infoHandler);
		//replay(debugHandler);
		Log.error("Error");
	}
	
	@Test
	public void testHandlerFiltering1()
	{
		Log.setLevel(Log.WARNING);
		expect(errorHandler.getLevel()).andReturn(Log.ERROR);
		errorHandler.write("Error", Log.ERROR);
		expect(warningHandler.getLevel()).andReturn(Log.WARNING);
		warningHandler.write("Error", Log.ERROR);
		expect(infoHandler.getLevel()).andReturn(Log.INFO);
		infoHandler.write("Error", Log.ERROR);
		expect(debugHandler.getLevel()).andReturn(Log.DEBUG);
		debugHandler.write("Error", Log.ERROR);
		replay(errorHandler);
		replay(warningHandler);
		replay(infoHandler);
		replay(debugHandler);
		Log.error("Error");
	}
	
	@Test
	public void testLoggerFiltering2()
	{
		Log.setLevel(Log.DEBUG);
		expect(errorHandler.getLevel()).andReturn(Log.ERROR);
		expect(warningHandler.getLevel()).andReturn(Log.WARNING);
		expect(infoHandler.getLevel()).andReturn(Log.INFO);
		infoHandler.write("Error", Log.INFO);
		expect(debugHandler.getLevel()).andReturn(Log.DEBUG);
		debugHandler.write("Error", Log.INFO);
		replay(errorHandler);
		replay(warningHandler);
		replay(infoHandler);
		replay(debugHandler);
		Log.info("Error");
	}
	
	@Test
	public void testLoggerClose() 
	{	
		errorHandler.close();
		warningHandler.close();
		infoHandler.close();
		debugHandler.close();
		replay(errorHandler);
		replay(warningHandler);
		replay(infoHandler);
		replay(debugHandler);
		Log.close();
	}
	
}
