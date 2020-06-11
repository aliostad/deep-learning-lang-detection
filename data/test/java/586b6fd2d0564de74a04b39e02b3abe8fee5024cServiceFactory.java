package service;

import java.util.*;

public final class ServiceFactory {

	private static ServiceFactory instance = null;

	private final Map<Class<? extends AbstractService>, AbstractService> services = new HashMap<>();

	private ServiceFactory() {
	}

	public static ServiceFactory getInstance() {
//		synchronized (instance) {
			if (instance == null) {
				instance = new ServiceFactory();
			}
//		}
		return instance;
	}

	public UserService getUserService() {
		UserService userService;

		synchronized (services) {
			userService = (UserService) services.get(UserService.class);

			if (userService == null) {
				userService = new UserServiceImpl();
				services.put(UserService.class, userService);
			}
		}

		return userService;
	}
	
	public GreetService getGreetService() {
		GreetService greetService;
		
		synchronized (services) {
			greetService = (GreetService) services.get(GreetService.class);
			
			if(greetService == null) {
				greetService = new GreetServiceImpl();
				services.put(GreetService.class, greetService);
			}
		}
		
		return greetService;
	}
}
