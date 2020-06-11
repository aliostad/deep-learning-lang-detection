package pe.gob.trabajo.pcd.servicio;

import pe.gob.trabajo.pcd.servicio.auditoria.AuditoriaService;
import pe.gob.trabajo.pcd.servicio.busqueda.ProfesionalService;
import pe.gob.trabajo.pcd.servicio.comun.EmpresaService;
import pe.gob.trabajo.pcd.servicio.comun.PedidoService;
import pe.gob.trabajo.pcd.servicio.comun.PersonaService;
import pe.gob.trabajo.pcd.servicio.maestro.MaestroService;
import pe.gob.trabajo.pcd.vista.locator.ServiceLocator;


// TODO: Auto-generated Javadoc
/**
 * The Class ServiceLocatorImpl.
 */
public class ServiceLocatorImpl implements ServiceLocator {
	
	/** The maestro service. */
	private MaestroService maestroService;
	
	/** The persona service. */
	private PersonaService personaService;
	
	/** The auditoria service. */
	private AuditoriaService auditoriaService;
	
	/** The profesional service. */
	private ProfesionalService profesionalService;
	
	/** The empresa service. */
	private EmpresaService empresaService;
	
	/** The pedido service. */
	private PedidoService  pedidoService;

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getMaestroService()
	 */
	public MaestroService getMaestroService() {
		return maestroService;
	}

	/**
	 * Sets the maestro service.
	 *
	 * @param maestroService the new maestro service
	 */
	public void setMaestroService(MaestroService maestroService) {
		this.maestroService = maestroService;
	}

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getPersonaService()
	 */
	public PersonaService getPersonaService() {
		return personaService;
	}

	/**
	 * Sets the persona service.
	 *
	 * @param personaService the new persona service
	 */
	public void setPersonaService(PersonaService personaService) {
		this.personaService = personaService;
	}

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getAuditoriaService()
	 */
	public AuditoriaService getAuditoriaService() {
		return auditoriaService;
	}

	/**
	 * Sets the auditoria service.
	 *
	 * @param auditoriaService the new auditoria service
	 */
	public void setAuditoriaService(AuditoriaService auditoriaService) {
		this.auditoriaService = auditoriaService;
	}

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getProfesionalService()
	 */
	public ProfesionalService getProfesionalService() {
		return profesionalService;
	}

	/**
	 * Sets the profesional service.
	 *
	 * @param profesionalService the new profesional service
	 */
	public void setProfesionalService(ProfesionalService profesionalService) {
		this.profesionalService = profesionalService;
	}

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getEmpresaService()
	 */
	public EmpresaService getEmpresaService() {
		return empresaService;
	}

	/**
	 * Sets the empresa service.
	 *
	 * @param empresaService the new empresa service
	 */
	public void setEmpresaService(EmpresaService empresaService) {
		this.empresaService = empresaService;
	}

	/* (non-Javadoc)
	 * @see pe.gob.trabajo.pcd.vista.locator.ServiceLocator#getPedidoService()
	 */
	public PedidoService getPedidoService() {
		return pedidoService;
	}

	/**
	 * Sets the pedido service.
	 *
	 * @param pedidoService the new pedido service
	 */
	public void setPedidoService(PedidoService pedidoService) {
		this.pedidoService = pedidoService;
	}
	
}
