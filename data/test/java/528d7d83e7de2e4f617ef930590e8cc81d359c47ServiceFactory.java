package service;

import service.jerarquia.AnimalService;
import service.jerarquia.GatoService;
import service.jerarquia.PerroService;

public class ServiceFactory {
	
	public static Service getService(String service){
		Service result = null;
		switch(service){
		case "Casa":
			result = new CasaService();
			break;
		case "Direccion":
			result = new DireccionService();
			break;
		case "Persona":
			result = new PersonaService();
			break;
		case "Animal":
			result = new AnimalService();
			break;
		case "Perro":
			result = new PerroService();
			break;
		case "Gato":
			result = new GatoService();
			break;
		}
		return result;
	}
}
