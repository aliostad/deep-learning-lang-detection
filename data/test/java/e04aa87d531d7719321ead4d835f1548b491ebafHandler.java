package edu.ist.smsserializer;

/**
 * This class implements a handler that treats SMS received SMS messages.
 * 
 * @author Grupo 1
 */
public class Handler implements IHandler {
	private static IHandler handler;

	private Handler() {
	}

	/**
	 * Obtains the Handler instance registered in this class.
	 * 
	 * @return A handler instance that handles received SMS messages.
	 */
	public static IHandler getHandler() {
		if (handler == null) {
			handler = new Handler();
		}
		return handler;
	}

	/**
	 * Set the handler to be used when handling incoming SMS messages.
	 * 
	 * @param handler
	 *            The handler instance to register
	 */
	public static void setHandler(IHandler handler) {
		Handler.handler = handler;
	}

	@Override
	public Object handleIncomingMessage(Object values) {
		System.out.println(values.toString());
		return null;
	}

}
