package com.excilys.formation.projet.service;

public class ServiceFactory {

	private static ServiceFactory instance = null;

	private ComputerService computerService = null;
	private CompanyService companyService = null;

	public final static ServiceFactory getInstance() {
		if (ServiceFactory.instance == null) {
			synchronized (ServiceFactory.class) {
				if (ServiceFactory.instance == null) {
					ServiceFactory.instance = new ServiceFactory();
				}
			}
		}
		return ServiceFactory.instance;
	}

	public ComputerService getComputerService() {
		return computerService;
	}
	
	private ServiceFactory() {
	
		this.computerService = new ComputerService();
		this.companyService = new CompanyService();
	}

	public CompanyService getCompanyService() {
		return companyService;
	}

	
}
