package dad.recetapp.services;

import dad.recetapp.services.impl.CategoriasService;
import dad.recetapp.services.impl.MedidasService;
import dad.recetapp.services.impl.RecetasService;
import dad.recetapp.services.impl.TiposAnotacionesService;
import dad.recetapp.services.impl.TiposIngredientesService;

public class ServiceLocator {

	private static final IRecetasService recetasService = new RecetasService();
	private static final IMedidasService medidasService = new MedidasService();
	private static final ITiposIngredientesService tiposIngredientesService = new TiposIngredientesService();
	private static final ICategoriasService categoriasService = new CategoriasService();
	private static final ITiposAnotacionesService tiposAnotacionesService = new TiposAnotacionesService();

	private ServiceLocator(){}
	
	public static IRecetasService getRecetasService() {
		return recetasService;
	}

	public static IMedidasService getMedidasService() {
		return medidasService;
	}

	public static ITiposIngredientesService getTiposIngredientesService() {
		return tiposIngredientesService;
	}

	public static ICategoriasService getCategoriasService(){
		return categoriasService;
	}

	public static ITiposAnotacionesService getTiposAnotacionesService() {
		return tiposAnotacionesService;
	}
}
