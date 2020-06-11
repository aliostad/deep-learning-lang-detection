/**
 * 
 */
package itjava.tests;

import itjava.model.Repository;
import itjava.model.RepositoryStore;

import org.junit.Test;
import static org.junit.Assert.*;

/**
 * @author student
 *
 */
public class RepositoryStoreTest {

	private Repository _repository = new Repository();

	@Test
	public void TestReadRepository() {
		_repository = RepositoryStore.UpdateRepository(null, null);
		ThenRepositoryHasImportTerms();
	}

	private void ThenRepositoryHasImportTerms() {
		assertTrue(_repository.importTerms.size() > 0);
	}
}
