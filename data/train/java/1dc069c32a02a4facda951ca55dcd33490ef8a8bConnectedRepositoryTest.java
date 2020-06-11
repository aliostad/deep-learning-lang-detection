// $Id$
package org.uccreator.repository;

import org.junit.Before;
import org.uccreator.repository.RepositoryConnectionException;
import org.uccreator.repository.UseCaseRepository;

/**
 * Repository that builds a connection at the start of each test.
 * @author Kariem Hussein
 */
public abstract class ConnectedRepositoryTest extends RepositoryTest {

	/** The connected repository */
	protected UseCaseRepository repos;

	/**
	 * Initializes the repository
	 * @throws RepositoryConnectionException
	 */
	@Before
	public void setUp() throws RepositoryConnectionException {
		repos = connectTo(DEFAULT_URL);
	}
	
	
	
}
