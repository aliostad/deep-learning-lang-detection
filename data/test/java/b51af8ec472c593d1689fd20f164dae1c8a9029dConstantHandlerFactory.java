package de.intarsys.tools.logging;

import java.util.logging.Handler;

/**
 * An {@link IHandlerFactory} that returns a constant {@link Handler} value.
 * 
 */
public class ConstantHandlerFactory extends CommonHandlerFactory {

	public ConstantHandlerFactory(Handler handler) {
		super();
		setSingleton(true);
		setSingletonHandler(handler);
	}

	@Override
	protected Handler basicCreateHandler() {
		return getSingletonHandler();
	}

	public Handler getHandler() {
		return getSingletonHandler();
	}

}
