package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.LoginRepository;

@Component
public class LoginService {

	@Autowired
	private LoginRepository loginRepository;

	public LoginRepository getLoginRepository() {
		return loginRepository;
	}

	public void setLoginRepository(LoginRepository loginRepository) {
		this.loginRepository = loginRepository;
	}

	
}
