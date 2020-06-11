package by.tc.tester.service;

import by.tc.tester.service.impl.TesterServiceImpl;
import by.tc.tester.service.impl.UserServiceImpl;

public class ServiceFactory {
	private static final ServiceFactory instance = new ServiceFactory();
	
	private TestService testService = new TesterServiceImpl();
	private UserService userService = new UserServiceImpl();

	public UserService getUserService() {
		return userService;
	}

	public static ServiceFactory getInstance(){
		return instance;
	}
	
	
	public TestService getTestService(){
		return testService;
	}

}
