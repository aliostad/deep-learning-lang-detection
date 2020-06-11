package com.klindziuk.offlinelibrary.service.factory;

import com.klindziuk.offlinelibrary.service.AdminService;
import com.klindziuk.offlinelibrary.service.ClientService;
import com.klindziuk.offlinelibrary.service.LibraryService;
import com.klindziuk.offlinelibrary.service.impl.AdminServiceImpl;
import com.klindziuk.offlinelibrary.service.impl.ClientServiceImpl;
import com.klindziuk.offlinelibrary.service.impl.LibraryServiceImpl;

public class ServiceFactory {
	private static final ServiceFactory instance = new ServiceFactory();
	private final ClientService clientService = new ClientServiceImpl(); 
	private final AdminService adminService = new AdminServiceImpl();
	private final LibraryService libraryService = new LibraryServiceImpl();
	
	private ServiceFactory() {}
	
	public static ServiceFactory getInstance() {
		return instance;
	}

	public ClientService getClientService() {
		return clientService;
	}

	public AdminService getAdminService() {
		return adminService;
	}

	public LibraryService getLibraryService() {
		return libraryService;
	}
}
