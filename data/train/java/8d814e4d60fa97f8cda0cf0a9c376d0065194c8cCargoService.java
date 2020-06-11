package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.CargoRepository;

@Component
public class CargoService {
	
	@Autowired
	private CargoRepository cargoRepository;

	public CargoRepository getCargoRepository() {
		return cargoRepository;
	}

	public void setCargoRepository(CargoRepository cargoRepository) {
		this.cargoRepository = cargoRepository;
	}
	
}
