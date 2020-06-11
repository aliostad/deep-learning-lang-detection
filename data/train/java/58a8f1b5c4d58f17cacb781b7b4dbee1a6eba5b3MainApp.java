public class MainApp {
	
	public static void main(String[] args) {
		final NumHandler handlerChain = setUpChain();
		
		// Schedule a job for the event dispatch thread:
		// creating and showing this application's GUI.
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				NumberHandlerWindow.createAndShowGUI(handlerChain);
			}
		});
	}
	
	public static NumHandler setUpChain() {
		NumHandler primeHandler = new PrimeHandler();
		NumHandler oddHandler = new OddHandler();
		NumHandler evenHandler = new EvenHandler();
		primeHandler.next = oddHandler;
		oddHandler.next = evenHandler;
		return primeHandler;
	}
}
