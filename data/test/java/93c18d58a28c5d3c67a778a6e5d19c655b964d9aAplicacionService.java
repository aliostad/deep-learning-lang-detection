package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.AplicacionRepository;

@Component
public class AplicacionService {
	
	@Autowired
	private AplicacionRepository aplicacionRepository ;

	public AplicacionRepository getAplicacionRepository() {
		return aplicacionRepository;
	}

	public void setAplicacionRepository(AplicacionRepository aplicacionRepository) {
		this.aplicacionRepository = aplicacionRepository;
	}





}
