/**
 * 
 */
package gr.ekt.cerif.services.semantics;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Persistence service for CERIF Semantic Features.
 * 
 */
@Component
public class SemanticsPersistenceService {
	
	/**
	 * The repository for classification classes.
	 */
	@Autowired
	private ClassRepository classRepository;

	@Autowired
	private ClassSchemeRepository classSchemeRepository;

	
	/**
	 * @return the classRepository
	 */
	public ClassRepository getClassRepository() {
		return classRepository;
	}

	/**
	 * @return the classSchemeRepository
	 */
	public ClassSchemeRepository getClassSchemeRepository() {
		return classSchemeRepository;
	}


	
}
