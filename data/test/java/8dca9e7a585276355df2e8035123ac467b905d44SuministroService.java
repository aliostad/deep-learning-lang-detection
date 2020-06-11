package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.SuministroRepository;


@Component
public class SuministroService {
	
	@Autowired
	private SuministroRepository suministroRepository;

	public SuministroRepository getSuministroRepository() {
		return suministroRepository;
	}

	public void setSuministroRepository(SuministroRepository suministroRepository) {
		this.suministroRepository = suministroRepository;
	}


}
