package se.viewer.image.gui.handlers;

/**
 * Class that delivers GUI handlers
 * @author Harald Brege
 */
public class GUIFactory {

	/**
	 * Creates a handler for the main viewer GUI 
	 * @return A new viewer GUI handler
	 */
	public static ViewerHandlerInterface getViewerHandler() {
		return new ViewerHandler();
	}
	
	/**
	 * Creates a handler for the login GUI
	 * @return A new login GUI handler
	 */
	public static LoginHandlerInterface getLoginHandler() {
		return new LoginHandler();
	}
}
