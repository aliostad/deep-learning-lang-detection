package by.nikolaev.ilya.barbershop.service;

import by.nikolaev.ilya.barbershop.service.administration.AdministrationService;
import by.nikolaev.ilya.barbershop.service.administration.impl.AdministrationServiseImpl;
import by.nikolaev.ilya.barbershop.service.impl.NewsServiceImpl;
import by.nikolaev.ilya.barbershop.service.impl.RecordServiceImpl;
import by.nikolaev.ilya.barbershop.service.impl.UserServiceImpl;

public class ServiceFactory {
	private static ServiceFactory instance = null;
	private final UserService userService = new UserServiceImpl();
	private final RecordService recordService = new RecordServiceImpl();
	private final AdministrationService administrationService = new AdministrationServiseImpl();
	private final NewsService newsService = new NewsServiceImpl();

	private ServiceFactory() {
	}

	public static ServiceFactory getInstance() {
		if (instance == null) {
			instance = new ServiceFactory();
		}
		return instance;
	}

	public UserService getUserService() {
		return userService;
	}

	public RecordService getRecordService() {
		return recordService;
	}

	public AdministrationService getAdministrationService() {
		return administrationService;
	}

	public NewsService getNewsService() {
		return newsService;
	}

}
