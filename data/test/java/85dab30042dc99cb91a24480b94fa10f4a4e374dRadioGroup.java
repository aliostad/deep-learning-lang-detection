package net.magik6k.jwwf.util;

import net.magik6k.jwwf.core.Group;
import net.magik6k.jwwf.handlers.SelectionHandler;

public final class RadioGroup extends Group {
	private SelectionHandler handler;

	/**
	 * Creates new RadioGroup with default selection hndler
	 *
	 * @param handler Handler to be fired when user selects some option
	 */
	public RadioGroup(SelectionHandler handler) {
		this.handler = handler;
	}

	public RadioGroup() {
	}

	/**
	 * Sets new selection handler
	 *
	 * @param handler Handler to be fired when user selects some option
	 * @return This instance for chaining
	 */
	public RadioGroup setHandler(SelectionHandler handler) {
		this.handler = handler;
		return this;
	}

	/**
	 * Internal use only
	 *
	 * @param userdata userdata
	 */
	public void select(Object userdata) {
		if (handler != null)
			handler.select(userdata);
	}

}
