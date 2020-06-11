/**
 * 
 */
package gr.ekt.cerif.services.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Persistence service for CERIF Base Entities.
 * 
 */
@Component
public class BasePersistenceService {

	/**
	 * The organisation repository.
	 */
	@Autowired
	private OrganisationUnitRepository organisationUnitRepository;
	
	/**
	 * The person repository.
	 */
	@Autowired
	private PersonRepository personRepository;
	
	/**
	 * The project repository.
	 */
	@Autowired
	private ProjectRepository projectRepository;
	
	
	/**
	 * @return the organisationUnitRepository
	 */
	public OrganisationUnitRepository getOrganisationUnitRepository() {
		return organisationUnitRepository;
	}

	/**
	 * @return the personRepository
	 */
	public PersonRepository getPersonRepository() {
		return personRepository;
	}

	/**
	 * @return the projectRepository
	 */
	public ProjectRepository getProjectRepository() {
		return projectRepository;
	}
	
	
}
