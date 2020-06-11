package dad.recetapp.services;

import dad.recetapp.services.impl.*;


public class ServiceLocator {
	private static IRecetasService recetasService = null;
	private static IMedidasService medidasService = null;
	private static ITiposIngredientesService tiposIngredientesService = null;
	private static ICategoriasService categoriasService = null;
	private static ITiposAnotacionesService tiposAnotacionesService = null;

	public static IRecetasService getRecetasService() {
		if(recetasService ==null){
			recetasService = new RecetasService();
			
		}
		return recetasService;
	}

	public static IMedidasService getMedidasService() {
		if(medidasService ==null){
			medidasService = new MedidasService();
			
		}
		return medidasService;
	}

	public static ITiposIngredientesService getTiposIngredientesService() {
		if(tiposIngredientesService ==null){
			tiposIngredientesService = new TiposIngredientesService();
			
		}
		return tiposIngredientesService;
	}

	public static ICategoriasService getCategoriasService() {
		if (categoriasService==null) {
			categoriasService = new CategoriasService();
			
		}
		return categoriasService;
	}

	public static ITiposAnotacionesService getTiposAnotacionesService() {
		if (tiposAnotacionesService==null) {
			tiposAnotacionesService = new TiposAnotacionesService();
			
		}
		return tiposAnotacionesService;
	}
}
