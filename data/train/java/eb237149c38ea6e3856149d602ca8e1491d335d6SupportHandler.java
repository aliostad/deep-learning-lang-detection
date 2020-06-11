package exercise.two;

import example.one.PurchaseRequest;

public abstract class SupportHandler {
	private SupportHandler nextHandler;

	// private String handlerName;
	//
	// public SupportHandler(String name) {
	// handlerName = name;
	// }
	//
	// public String getHandlerName() {
	// return handlerName;
	// }

	public abstract boolean resolving(SupportRequest request);

	public SupportHandler getNextHandler() {
		return nextHandler;
	}

	public void setNextHandler(SupportHandler nextHandler) {
		this.nextHandler = nextHandler;
	}
}
