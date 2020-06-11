package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.UbicacionRepository;

@Component
public class UbicacionService {
	
	@Autowired
	private UbicacionRepository ubicacionRepository;

	public UbicacionRepository getUbicacionRepository() {
		return ubicacionRepository;
	}

	public void setUbicacionRepository(UbicacionRepository ubicacionRepository) {
		this.ubicacionRepository = ubicacionRepository;
	}

	
	
}
