package net.javabeat.springdata.beans;

import net.javabeat.springdata.repo.EmployeeRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class RegistrationService {
	@Autowired
	private EmployeeRepository repository;
	
	public RegistrationService(){

	}

	public EmployeeRepository getRepository() {
		return repository;
	}

	public void setRepository(EmployeeRepository repository) {
		this.repository = repository;
	}

}
