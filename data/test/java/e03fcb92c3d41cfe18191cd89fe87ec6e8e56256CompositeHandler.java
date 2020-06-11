package de.intarsys.tools.logging;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Handler;
import java.util.logging.LogRecord;

/**
 * A Java logging {@link Handler} that forwards to a collection of other
 * {@link Handler} instances.
 * 
 */
public class CompositeHandler extends Handler {

	private List<Handler> handlers = new ArrayList<Handler>();

	public void addHandler(Handler handler) {
		handlers.add(handler);
	}

	@Override
	public void close() throws SecurityException {
		for (Handler handler : handlers) {
			handler.close();
		}
	}

	@Override
	public void flush() {
		for (Handler handler : handlers) {
			handler.flush();
		}
	}

	public Handler[] getHandlers() {
		return handlers.toArray(new Handler[handlers.size()]);
	}

	@Override
	public void publish(LogRecord record) {
		for (Handler handler : handlers) {
			handler.publish(record);
		}
	}

	public void removeHandler(Handler handler) {
		handlers.remove(handler);
	}

}
