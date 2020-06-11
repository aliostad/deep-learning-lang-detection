/**
 * 
 */
package gr.ekt.cerif.services.result;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Persistence service for CERIF Result Entities.
 * 
 */
@Component
public class ResultPersistenceService {

	@Autowired
	private ResultPatentRepository resultPatentRepository;
	
	@Autowired
	private ResultProductRepository resultProductRepository;
	
	@Autowired
	private ResultPublicationRepository resultPublicationRepository;

	
	/**
	 * @return the resultPatentRepository
	 */
	public ResultPatentRepository getResultPatentRepository() {
		return resultPatentRepository;
	}

	/**
	 * @return the resultProductRepository
	 */
	public ResultProductRepository getResultProductRepository() {
		return resultProductRepository;
	}

	/**
	 * @return the resultPublicationRepository
	 */
	public ResultPublicationRepository getResultPublicationRepository() {
		return resultPublicationRepository;
	}
	
	

}
