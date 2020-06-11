package pe.edu.cibertec.proyemp.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import pe.edu.cibertec.proyemp.repository.AtributoRepository;


@Component
public class AtributoService {
	
	@Autowired
	private AtributoRepository atributoRepository;

	public AtributoRepository getAtributoRepository() {
		return atributoRepository;
	}

	public void setAtributoRepository(AtributoRepository atributoRepository) {
		this.atributoRepository = atributoRepository;
	}



}
