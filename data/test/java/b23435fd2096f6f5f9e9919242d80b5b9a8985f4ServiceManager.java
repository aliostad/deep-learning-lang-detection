package com.formation.jee.service.manager;

import com.formation.jee.service.CompanyService;
import com.formation.jee.service.ComputerService;
import com.formation.jee.service.impl.CompanyServiceImpl;
import com.formation.jee.service.impl.ComputerServiceImpl;

public enum ServiceManager {
	INSTANCE;
	
	private CompanyService companyService;
	private ComputerService computerService;
	
	private ServiceManager(){
		companyService=new CompanyServiceImpl();
		computerService=new ComputerServiceImpl();
	}
	
	public CompanyService getCompanyService(){
		return companyService;
	}
	
	public ComputerService getComputerService(){
		return computerService;
	}
}
