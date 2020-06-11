package sgc.service;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServiceFactory implements Serializable {

	private static final long serialVersionUID = 1L;

	@Autowired
	private PersonaService personaService;
	
	@Autowired
	private UsuarioService usuarioService;
	
	public PersonaService getPersonaService() {
		return personaService;
	}
	
	public UsuarioService getUsuarioService() {
		return usuarioService;
	}
	
	
	
}
