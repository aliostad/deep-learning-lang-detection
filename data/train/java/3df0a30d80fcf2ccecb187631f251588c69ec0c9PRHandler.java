package chain_of_responsibility2;

public abstract class PRHandler {

	private PRHandler nextHandler;
	private String handlerName;

	public PRHandler(String handlerName) {
		super();
		this.handlerName = handlerName;
	}

	public abstract boolean authorized(PurchaseRequest request);

	public PRHandler getNextHandler() {
		return nextHandler;
	}

	public String getHandlerName() {
		return handlerName;
	}

	public void setHandlerName(String handlerName) {
		this.handlerName = handlerName;
	}

	public void setNextHandler(PRHandler nextHandler) {
		this.nextHandler = nextHandler;
	}

}
