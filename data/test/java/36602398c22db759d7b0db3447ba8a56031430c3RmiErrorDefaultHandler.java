package rmi;

public class RmiErrorDefaultHandler {
	abstract public static class ErrorDefaultHandlerBase
	{
		abstract public void onError(String what, int code);
	}
	
	public static ErrorDefaultHandlerBase defaultHandler = null;
	
	public static void setErrorDefaultHandler(ErrorDefaultHandlerBase defaultHandler)
	{
		RmiErrorDefaultHandler.defaultHandler = defaultHandler;
	}
	
	public static void onError(String what, int code)
	{
		if (RmiErrorDefaultHandler.defaultHandler != null)
		{
			RmiErrorDefaultHandler.defaultHandler.onError(what, code);
		}
	}
}
