package ia.project.mmm.service;

import ia.project.mmm.model.Message;
import ia.project.mmm.model.UserInfo;

/**
 *
 * @author Mohamed Kamal
 */
public class ServiceLocater {
    private static IUserService userService = new UserService();
    private static IMessageService messageService = new MessageService();
    
    public static IMessageService getMessageService(){
        return messageService;
    }
    
    public static IUserService getUserService(){
        return userService;
    }
}
