package com.spring4.annoation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

@Component
public class EmployeeController {
	
	
	
	private EmployeeService service;

	public EmployeeService getService() {
		return service;
	}

	@Autowired(required=false)
	public void setService(EmployeeService service) {
		this.service = service;
	}
	
	@Autowired
	@Qualifier("option2")
	private DepartmentService departmentService;

	public DepartmentService getDepartmentService() {
		return departmentService;
	}

	public void setDepartmentService(DepartmentService departmentService) {
		this.departmentService = departmentService;
	}
	
	
	

}
