
public abstract class Handler {
	private Handler next;
	
	protected abstract void processMail(Mail mail);
	
	public void process(Mail mail)
	{
		Handler currentHandler = this;
		
		do {
			currentHandler.process(mail);
		} while ((currentHandler = currentHandler.getNext()) != null);
	}
	
	public void addNextHandler(Handler next) {
		Handler currentHandler = this;
		while (currentHandler.getNext() != null) {
			currentHandler = currentHandler.getNext();
		}
		currentHandler.setNext(next);
	}

	public void setNext(Handler next) {
		this.next = next;
	}
	
	public Handler getNext() {
		return this.next;
	}
}
