package persistence.servicefactory;

import persistence.jpa.*;
import persistence.service.*;

public class JPAServiceFactory extends ServiceFactory {

	@Override
	public GuiaService getGuiaService() {
		return new JPAGuiaService();
	}

	@Override
	public ProductoService getProductoService() {
		return new JPAProductoService();
	}

	@Override
	public TareaService getTareaService() {
		return new JPATareaService();
	
	}

	@Override
	public UbicacionService getUbucacionService() {
		return new JPAUbicacionService();
	}

	@Override
	public UsuarioService getUsuarioService() {
		return new JPAUsuarioService();
	}

}
