package de.hsrm.perfunctio.core.shared.handler;

import java.util.ArrayList;
import java.util.List;

public abstract class AbstractHandlerManager {

	protected List<AbstractHandler> handler;

	public AbstractHandlerManager() {
		handler = new ArrayList<AbstractHandler>();
	}

	/**
	 * Adds the assigned handler to the end of chain
	 * 
	 * @param newHandler
	 */
	public void appendHandler(AbstractHandler newHandler) {
		if (handler.size() > 0) {
			handler.get(handler.size() - 1).setNext(newHandler);
		}
		handler.add(newHandler);
	}

	/**
	 * Adds the handler to the chain depending on their priorities. Default: 100
	 * FileChooserFormHandler; 200 DroppedFileMetadataHandler; 300
	 * UnknownFileFormatHandler; 400 MultipleFiletypesHandler; 500
	 * FileDataHandler
	 * 
	 * @param newHandler
	 *            The AbstractClientHandler to add
	 */
	public void addHandler(AbstractHandler newHandler) {
		int prio = newHandler.getPriority();

		for (int i = 0; i < handler.size(); i++) {
			// check priority order
			if (handler.get(i).getPriority() > prio) {
				addHandlerToIndex(newHandler, i);
				return;
			}
		}
		// priority greater than last handler
		appendHandler(newHandler);
	}

	private void addHandlerToIndex(AbstractHandler newHandler, int index) {
		int handlerCount = handler.size();
		if (index >= handlerCount) {
			appendHandler(newHandler);
		} else {
			if (index <= 0) {
				handler.get(0).setNext(newHandler);
			} else {
				handler.get(index - 1).setNext(newHandler);
			}
			handler.add(index, newHandler);
			newHandler.setNext(handler.get(index + 1));
		}
	}

	/**
	 * @return the handlerlist
	 */
	public List<AbstractHandler> getHandler() {
		return handler;
	}

	/**
	 * @return true if the manager manages at least one handler
	 */
	public boolean hasHandler() {
		return handler.size() > 0;
	}

}
