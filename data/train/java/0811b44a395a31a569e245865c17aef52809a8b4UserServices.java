package pl.rea.client.service;

import java.util.List;

import pl.rea.client.webmethods.users.UserCanonical;
import pl.rea.client.webmethods.users.UserService;
import pl.rea.client.webmethods.users.UserService_Service;

public class UserServices {
	
	public boolean userExists(String login){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.userExists(login);
	}
	
	public String logIn(String login, String password){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.logIn(login, password);
	}
	
	public boolean isUserLogged(String login, String sessionId){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.isUserLogged(login, sessionId);
	}
	
	public boolean isAdminLogged(String login, String sessionId){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.isAdminLogged(login, sessionId);
	}
	
	public boolean createUser(UserCanonical user){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.createUser(user);
	}
	
	public boolean deleteUser(String login, String sessionId, String userToDelete){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.deleteUser(login, sessionId, userToDelete);
	}
	
	public boolean editUser(String login, String sessionId, UserCanonical userToEdit){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.editUser(login, sessionId, userToEdit);
	}
	
	public UserCanonical getUser(String login, String sessionId, String userToGet){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.getUser(login, sessionId, userToGet);
	}
	
	public List<UserCanonical> getUserList(String login, String sessionId){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.getUserList(login, sessionId);
	}
	
	public boolean isAnybodyLogged(String login, String sessionId){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.isAnybodyLogged(login, sessionId);
	}
	
	public boolean logOut(String login, String sessionId){
		UserService_Service userService = new UserService_Service();
		UserService service = userService.getUserServicePort();
		return service.logOut(login, sessionId);
	}
	
	

}
