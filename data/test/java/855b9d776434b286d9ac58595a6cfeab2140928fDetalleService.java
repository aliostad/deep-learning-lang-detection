package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.DetalleRepository;

@Component
public class DetalleService {

	
	@Autowired
	private DetalleRepository detalleRepository;

	public DetalleRepository getDetalleRepository() {
		return detalleRepository;
	}

	public void setDetalleRepository(DetalleRepository detalleRepository) {
		this.detalleRepository = detalleRepository;
	}


}
