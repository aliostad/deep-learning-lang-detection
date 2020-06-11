package fr.insa.rouen.bpm.services.process;

import fr.insa.rouen.bpm.model.process.ProcessPayLoad;

/**
 * Service de pilotage des process.
 * 
 * @author olivier
 *
 */
public interface ProcessManagerService {

	/**
	 * Démarre une instance de process qui commence par une Task.
	 * 
	 * L'utilisateur est inséré.
	 * La définition de process est passée en paramètres.
	 * Les variables de process sont dans le payload (typiquement la commande).
	 * 
	 * @param processPayload
	 * @param processName
	 * @param userId
	 * @return l'indentifiant de l'instance de process.
	 */
	public Long startProcessWithTask(ProcessPayLoad processPayload, String processName, Long userId);	
}
