package project.service;

import project.service.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class RegistrationService {
	@Autowired
	private UserRepository repository;
	
	public RegistrationService(){
		repository = getRepository();
	}

	public UserRepository getRepository() {
		return repository;
	}

	public void setRepository(UserRepository repository) {
		this.repository = repository;
	}

}
