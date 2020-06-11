
package messageservice;

/**
 *
 * @author Kallie
 */
public class MessageService {
    private MessageServiceStrategy serviceStrategy;

    public MessageService(){
        
    }
    public MessageService(MessageServiceStrategy serviceStrategy) {
        this.serviceStrategy = serviceStrategy;
    }

    public MessageServiceStrategy getServiceStrategy() {
        return serviceStrategy;
    }

    public void setServiceStrategy(MessageServiceStrategy serviceStrategy) {
        this.serviceStrategy = serviceStrategy;
    }
    
    public String chooseMessage(){
        return serviceStrategy.getMessage();
    }
}
