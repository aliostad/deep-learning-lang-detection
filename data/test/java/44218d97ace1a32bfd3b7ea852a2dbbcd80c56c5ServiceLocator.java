package dad.recetapp.services;

import dad.recetapp.services.impl.CategoriasService;
import dad.recetapp.services.impl.MedidasService;
import dad.recetapp.services.impl.RecetasService;
import dad.recetapp.services.impl.TipoAnotacionesService;
import dad.recetapp.services.impl.TipoIngredienteService;

public class ServiceLocator {
	
	private static final ICategoriaServices categoriaService = new CategoriasService();
	private static final IRecetasService recetasService = new RecetasService();
	private static final IMedidasService medidasService = new MedidasService();
	private static final ITipoIngredienteService tiposIngredientesService = new TipoIngredienteService();
	private static final ITipoAnotacionesService tiposAnotacionesService = new TipoAnotacionesService();
	
	public ServiceLocator() {}
	
	public static ICategoriaServices getCategoriasService(){
		return categoriaService;
	}

	
	public static IRecetasService getRecetasService() {
		return recetasService;
	}

	public static IMedidasService getMedidasService() {
		return medidasService;
	}

	public static ITipoIngredienteService getTiposIngredientesService() {
		return tiposIngredientesService;
	}


	public static ITipoAnotacionesService getTiposAnotacionesService() {
		return tiposAnotacionesService;
	}
}
