package com.locator;

import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.service.AccountServiceImpl;
import com.service.AccountServiceInt;
import com.service.MailServiceImpl;
import com.service.MailServiceInt;
import com.service.UserServiceImpl;
import com.service.UserServiceInt;

/**
 * This is Service locator and it is factory of service class
 * @author Chandrabhan
 *	@version 1.1
 */
public class ServiceLocator {
	/**
	 * Logger to record logs in file
	 */
	private static Logger LOGGER = Logger.getLogger(ServiceLocator.class);
	/**
	 * Private class type variable
	 */
	private static ServiceLocator serviceLocator = null;
	private static final String service = "JavaBean";
	/**
	 * Map instance for contain service object.
	 */
	private static Map session = new HashMap();
	/**
	 * Private cunstroctor for singlton 
	 */

	private ServiceLocator() {
	}
	/**
	 * getinstance method
	 * @return serviceLocator
	 */

	public static ServiceLocator getInstance() {
		LOGGER.debug("Debug:Now in getInstance() ServiceLocator");
		if (serviceLocator == null) {
			serviceLocator = new ServiceLocator();
		}
		return serviceLocator;
	}
	/**
	 * getAccountService Method
	 * @return AccountServiceInt instance
	 */
	public AccountServiceInt getAccountService() {
		LOGGER.debug("Debug:Now in getAccountService() ServiceLocator");
		AccountServiceInt accountService = (AccountServiceInt) session
				.get("accountService");

		if (accountService == null) {
			if ("JavaBean".equals(service)) {
				LOGGER
						.debug("Debug:Now in getAccountService() JAVABeanImpl ServiceLocator");
				accountService = new AccountServiceImpl();
			}
			if ("EJB".equals(service)) {
				LOGGER
						.debug("Debug:Now in getAccountService()EJBImpl ServiceLocator not Implemented yet");
				accountService = null;
				System.out.println();
			}
			session.put("accountService", accountService);
		}
		return accountService;
	}
	/**
	 * getUserService Method
	 * @return UserServiceInt instance
	 */

	public UserServiceInt getUserService() {
		LOGGER.debug("Debug:Now in getUserService() ServiceLocator");
		UserServiceInt userService = (UserServiceInt) session
				.get("userService");

		if (userService == null) {
			if ("JavaBean".equals(service)) {
				LOGGER.debug("Debug:Now in getUserService() ServiceLocator");
				userService = new UserServiceImpl();
			}
			if ("EJB".equals(service)) {
				LOGGER
						.debug("Debug:Now in getUserService() ServiceLocator not Implemented yet");
				userService = null;
			}
			session.put("userService", userService);
		}
		return userService;
	}
	
	/**
	 * getMailService Method
	 * @return UserServiceInt instance
	 */

	public MailServiceInt getMailService() {
		LOGGER.debug("Debug:Now in getMailService() ServiceLocator");
		MailServiceInt mailService= (MailServiceInt) session
				.get("mailService");

		if (mailService == null) {
			if ("JavaBean".equals(service)) {
				LOGGER.debug("Debug:Now in getMailService() ServiceLocator");
				mailService = new MailServiceImpl();
			}
			if ("EJB".equals(service)) {
				LOGGER
						.debug("Debug:Now in getMailService() ServiceLocator not Implemented yet");
				mailService = null;
			}
			session.put("mailService", mailService);
		}
		return mailService;
	}

}
