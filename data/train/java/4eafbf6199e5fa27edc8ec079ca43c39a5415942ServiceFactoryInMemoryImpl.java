package me.stronglift.api.service.inmemory;

import me.stronglift.api.service.LiftService;
import me.stronglift.api.service.ServiceFactory;
import me.stronglift.api.service.UserService;

/**
 * Fabrika koja proizvodi in-memory servise
 * 
 * @author Dusan Eremic
 *
 */
public class ServiceFactoryInMemoryImpl extends ServiceFactory {
	
	protected LiftService liftService;
	protected UserService userService;
	
	/** Vraća {@link LiftService} */
	@Override
	public LiftService getLiftService() {
		if (liftService == null) {
			liftService = new LiftServiceInMemoryImpl();
		}
		return liftService;
	}
	
	/** Vraća {@link UserService} */
	@Override
	public UserService getUserService() {
		if (userService == null) {
			userService = new UserServiceInMemoryImpl();
		}
		return userService;
	}
	
}
