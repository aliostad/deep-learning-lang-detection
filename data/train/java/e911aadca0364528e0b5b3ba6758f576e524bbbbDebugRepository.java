package com.sirma.itt.emf.semantic.debug;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.base.RepositoryWrapper;

/**
 * Repository wrapper class creating connections with logic for debug logging operations
 * 
 * @author kirq4e
 */
public class DebugRepository extends RepositoryWrapper {

	/**
	 * Initializes the instance and delegate
	 * 
	 * @param repository
	 *            repository intance
	 */
	public DebugRepository(Repository repository) {
		super(repository);
	}

	@Override
	public RepositoryConnection getConnection() throws RepositoryException {
		RepositoryConnection connection = super.getConnection();
		return new DebugRepositoryConnection(getDelegate(), connection);
	}
}
