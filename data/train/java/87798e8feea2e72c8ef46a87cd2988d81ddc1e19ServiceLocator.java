package dad.recetapp.services;

import dad.recetapp.services.impl.CategoriasService;
import dad.recetapp.services.impl.MedidasService;
import dad.recetapp.services.impl.RecetasService;
import dad.recetapp.services.impl.TipoAnotacionService;
import dad.recetapp.services.impl.TipoIngredienteService;

public class ServiceLocator {
	
	
	private static final IRecetasService recetasService = new RecetasService();
	private static final IMedidasService medidasService = new MedidasService();
	private static final ITiposIngredientesService tiposIngredientesService = new TipoIngredienteService();
	private static final ICategoriasService categoriasService = new CategoriasService();
	private static final ITiposAnotacionesService tiposAnotacionesService = new TipoAnotacionService();
	
	public ServiceLocator() {}

	public static IRecetasService getIRecetasService(){
		return recetasService;
	}
	public static IMedidasService getIMedidasService(){
		return medidasService;
	}
	public static ITiposIngredientesService getITiposIngredientesService(){
		return tiposIngredientesService;
	}
	public static ICategoriasService getICategoriasService() {
		return categoriasService;
	}
	public static ITiposAnotacionesService getITiposAnotacionesService(){
		return tiposAnotacionesService;
	}
}
