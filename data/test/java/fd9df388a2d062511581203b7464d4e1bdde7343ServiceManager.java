package com.formation.jee.service.manager;

import com.formation.jee.service.CompanyService;
import com.formation.jee.service.ComputerService;
import com.formation.jee.service.impl.CompanyServiceImpl;
import com.formation.jee.service.impl.ComputerServiceImpl;

public enum ServiceManager {

	INSTANCE;

	private ComputerService computerService;
	private CompanyService companyService;

	private ServiceManager() {
		computerService = new ComputerServiceImpl();
		companyService = new CompanyServiceImpl();
	}

	public ComputerService getComputerService() {
		return computerService;
	}

	public CompanyService getCompanyService() {
		return companyService;
	}
}
