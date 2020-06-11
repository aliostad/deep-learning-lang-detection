package com.dibellastudios.simplecalculator.processor;

import com.dibellastudios.simplecalculator.handler.OperationHandler;

/**
 * Used for loading the handlers of the chain of responsability
 * @author giuseppe
 *
 */
public class OperationProcessor {

	OperationHandler baseHandler;
	OperationHandler lastHandler;

	public OperationProcessor() {
	}

	public void addHandler(OperationHandler opHandler) {
		if (this.baseHandler == null) {
			this.baseHandler = opHandler;
		} else {
			this.lastHandler.setNext(opHandler);
		}
		this.lastHandler = opHandler;
	}

	public void handleRequest() {
		if (baseHandler != null) {
			baseHandler.handleRequest(baseHandler.getOperation());
		}
	}

}
