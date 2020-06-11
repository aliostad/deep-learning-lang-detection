package EmailExample;


public abstract class AbstractEmailHandler implements EmailHandler {
    private EmailHandler nextHandler;
 
    public void setNextHandler(EmailHandler handler) {
        nextHandler = handler;
    }
    public void processHandler(String email) {
        boolean wordFound = false;
        if (matchingWords().length == 0) {
            wordFound = true;
        } else {
             for (String word : matchingWords()) {
                if (email.indexOf(word) >= 0) {
                    wordFound = true;
                    break;
                }
            }
        }
	 if (wordFound) {
            handleHere(email);
        } else {
               nextHandler.processHandler(email);
        }
    }
 
    
    public static void handle(String email) {
        // Create the handler objects...
        EmailHandler spam = new SpamEmailHandler();
        EmailHandler sales = new SalesEmailHandler();
        EmailHandler service = new ServiceEmailHandler();
        EmailHandler manager = new ManagerEmailHandler();
        EmailHandler general = new GeneralEnquiriesEmailHandler();
        // Chain them together...
        spam.setNextHandler(sales);
        sales.setNextHandler(service);
        service.setNextHandler(manager);
        manager.setNextHandler(general);
        // Start the ball rolling...
        spam.processHandler(email);
    }

    
    protected abstract String[] matchingWords();
    protected abstract void handleHere(String email);
}        
