package dim;

public class DimExitHandler implements ExitHandler
{
		
	static // force loading the native library
	{
	  Native.loadNativeLibrary();
	}
/*
	public DimExitHandler()
	{
		DimExit.setHandler(this);
		addExitHandler();		
	}
	public static void addExitHandler(DimExitHandler handler)
	{
		DimExit.setHandler(handler);
		addExitHandler();
	}
*/
	public static native void  addExitHandler();

	public static void setHandler(DimExitHandler handler)
	{
		DimExit.setHandler(handler);
		addExitHandler();		
	}

	public void exitHandler(int code) 
	{
	}
	
	private static class DimExit implements ExitHandler
	{
		static DimExitHandler theExitHandler;
	
		DimExit() {}
		
		public static void setHandler(DimExitHandler handler)
		{
			theExitHandler = handler;
		}
	
		public void exitHandler(int code) 
		{
//			System.out.println("Server: "+code);
			theExitHandler.exitHandler(code);
		};
	}
}

interface ExitHandler
{
		void exitHandler(int code);
}