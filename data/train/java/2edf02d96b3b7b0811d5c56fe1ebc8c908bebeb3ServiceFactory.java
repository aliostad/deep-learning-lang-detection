package com.notariaberrospi.sgn.service;

import java.io.Serializable;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.notariaberrospi.sgn.util.Propiedades;

@Service
public class ServiceFactory implements Serializable {

	private static final long serialVersionUID = 1L;

	@Autowired
	private Propiedades properties;

	@Autowired
	private UsuarioService usuarioService;
	
	@Autowired
	private PersonaService personaService;
	
	@Autowired
	private MaestroService tablaService;
	
	@Autowired
	private KardexService kardexService;

	@Autowired
	private ActoService actoService;
	
	@Autowired
	private IntervinienteEmpresaService intervinienteEmpresaService;

	
	@Autowired
	private IntervinientePersonaService intervinientePersonaService;

	
	@Autowired
	private EmpleadoService empleadoService;

	
	@Autowired
	private EmpresaService empresaService;
	
	
	@Autowired
	private AbogadoService abogadoService;
	
	public Propiedades getProperties() {
		return properties;
	}

	public void setProperties(Propiedades properties) {
		this.properties = properties;
	}

	public UsuarioService getUsuarioService() {
		return usuarioService;
	}

	public void setUsuarioService(UsuarioService usuarioService) {
		this.usuarioService = usuarioService;
	}

	public PersonaService getPersonaService() {
		return personaService;
	}

	public void setPersonaService(PersonaService personaService) {
		this.personaService = personaService;
	}

	public MaestroService getTablaService() {
		return tablaService;
	}

	public void setTablaService(MaestroService tablaService) {
		this.tablaService = tablaService;
	}

	public KardexService getKardexService() {
		return kardexService;
	}

	public void setKardexService(KardexService kardexService) {
		this.kardexService = kardexService;
	}

	public ActoService getActoService() {
		return actoService;
	}

	public void setActoService(ActoService actoService) {
		this.actoService = actoService;
	}

	public IntervinienteEmpresaService getIntervinienteEmpresaService() {
		return intervinienteEmpresaService;
	}

	public void setIntervinienteEmpresaService(
			IntervinienteEmpresaService intervinienteEmpresaService) {
		this.intervinienteEmpresaService = intervinienteEmpresaService;
	}

	public IntervinientePersonaService getIntervinientePersonaService() {
		return intervinientePersonaService;
	}

	public void setIntervinientePersonaService(
			IntervinientePersonaService intervinientePersonaService) {
		this.intervinientePersonaService = intervinientePersonaService;
	}

	public EmpleadoService getEmpleadoService() {
		return empleadoService;
	}

	public void setEmpleadoService(EmpleadoService empleadoService) {
		this.empleadoService = empleadoService;
	}

	public EmpresaService getEmpresaService() {
		return empresaService;
	}

	public void setEmpresaService(EmpresaService empresaService) {
		this.empresaService = empresaService;
	}

	public AbogadoService getAbogadoService() {
		return abogadoService;
	}

	public void setAbogadoService(AbogadoService abogadoService) {
		this.abogadoService = abogadoService;
	}

	
}
