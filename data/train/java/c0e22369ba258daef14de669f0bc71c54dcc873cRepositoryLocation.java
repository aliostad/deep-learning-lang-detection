// $Id$
package org.uccreator.repository;

/**
 * Repository location that consists of a {@link UseCaseRepository} and a path
 * in this repository to locate a single entry.
 * 
 * @author Kariem Hussein
 */
public class RepositoryLocation {

	private final UseCaseRepository repository;
	private final String path;
	
	/**
	 * @param repository
	 * @param path
	 */
	public RepositoryLocation(UseCaseRepository repository, String path) {
		this.repository = repository;
		this.path = path;
	}

	/**
	 * @return the repository
	 */
	public UseCaseRepository getRepository() {
		return repository;
	}

	/**
	 * @return the path
	 */
	public String getPath() {
		return path;
	}
	
}
