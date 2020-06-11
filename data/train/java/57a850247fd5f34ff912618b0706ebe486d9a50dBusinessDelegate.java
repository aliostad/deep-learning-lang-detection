package pe.com.nextel.service;

/**
 * @author Devos Inc.
 * Clase que maneja todos los servicios, obteniendo la instancia solicitada.
 * 
 */

public class BusinessDelegate {
	
	private BusinessDelegate() {
		
	}
	
	public static UsuarioService getUsuarioService(){
		return new UsuarioServiceImpl();
	}
	
	public static PuntoInteresService getPuntoInteresService(){
		return new PuntoInteresServiceImpl();
	}
	
	public static GeocercaService getGeocercaService(){
		return new GeocercaServiceImpl();
	}
	
	public static CategoriaService getCategoriaService(){
		return new CategoriaServiceImpl();
	}
	
	public static HandsetService getHandsetService(){
		return new HandsetServiceImpl();
	}
	
	public static GrupoService getGrupoService(){
		return new GrupoServiceImpl();
	}
	
	public static TrackingService getTrackingService(){
		return new TrackingServiceImpl();
	}
	
	public static CuentaService getCuentaService(){
		return new CuentaServiceImpl();
	}
	
	public static AuditoriaService getAuditoriaService(){
		return new AuditoriaServiceImpl();
	}
	
	public static ReporteService getReporteService(){
		return new ReporteServiceImpl();
	}

	public static LogService getLogService(){
		return new LogServiceImpl();
	}

}
