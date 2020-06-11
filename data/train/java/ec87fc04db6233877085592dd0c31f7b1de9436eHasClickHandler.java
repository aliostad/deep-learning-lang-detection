package nl.wijsmullerbros;

/**
 * Holds a click handler.
 * <br><br>
 * No need for an interface since the implementation
 * is not dependent on the GUI system.
 * 
 * @author bwijsmuller
 */
public class HasClickHandler {
	private ClickHandler handler = null;
	/**
	 * Gets the handler
	 * @return the ClickHandler
	 */
	public ClickHandler getHandler() {
		return handler;
	}
	/**
	 * Sets the handler
	 * @param handler the ClickHandler
	 */
	public void setHandler(ClickHandler handler) {
		this.handler = handler;
	}
}
