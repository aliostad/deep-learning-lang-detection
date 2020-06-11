package de.intarsys.tools.logging;

import java.util.logging.Handler;
import java.util.logging.LogRecord;

/**
 * A {@link Handler} to delegate requests. This is the base implementation for
 * some useful {@link Handler} wrapper...
 * 
 */
public class DelegatingHandler extends Handler {

	final private Handler baseHandler;

	public DelegatingHandler() {
		super();
		// getBaseHandler will be redefined...
		this.baseHandler = null;
	}

	public DelegatingHandler(Handler handler) {
		super();
		this.baseHandler = handler;
	}

	@Override
	public void close() throws SecurityException {
		Handler tempHandler = getBaseHandler();
		if (tempHandler != null) {
			tempHandler.close();
		}
	}

	@Override
	public void flush() {
		Handler tempHandler = getBaseHandler();
		if (tempHandler != null) {
			tempHandler.flush();
		}
	}

	public Handler getBaseHandler() {
		return baseHandler;
	}

	@Override
	public void publish(LogRecord record) {
		Handler tempHandler = getBaseHandler();
		if (tempHandler != null) {
			tempHandler.publish(record);
		}
	}

}
