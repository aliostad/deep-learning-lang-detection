package org.effrafax.comiccollection.domain.provider;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.effrafax.comiccollection.domain.repository.Repository;
import org.junit.Test;

/**
 * Tests the provider
 * 
 * @author dvberkel
 */
public class ProviderTest {

	/**
	 * Test is a repository can be returned.
	 */
	@Test
	public void testGettingARepository() {

		Repository repository = Provider.PROVIDER.getRepository();
		assertNotNull(repository);
	}

	/**
	 * Test is repository is a singleton.
	 */
	@Test
	public void testGettingARepositoryTwice() {

		Repository firstRepository = Provider.PROVIDER.getRepository();
		Repository secondRepository = Provider.PROVIDER.getRepository();

		assertEquals(firstRepository, secondRepository);
	}
}
