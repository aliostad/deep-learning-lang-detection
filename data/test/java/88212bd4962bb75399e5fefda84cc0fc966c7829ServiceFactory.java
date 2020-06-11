/**
 * 
 */
package es.gabrielferreiro.apps.ardelucusmmxiv.service.impl;

/**
 * @author Gabriel
 *
 */
public class ServiceFactory {

	private static EventoServiceImpl eventoService = null;
	private static LocalServiceImpl localService = null;
	
	public static EventoServiceImpl getEventoService() {
		if (eventoService == null) {
			eventoService = new EventoServiceImpl();
		}
		
		return eventoService;
	}
	
	public static LocalServiceImpl getLocalService() {
		if (localService == null) {
			localService = new LocalServiceImpl();
		}
		
		return localService;
	}
	
}
