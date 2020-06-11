package de.proskor.model;

/**
 * Repository provider for the tests.
 * Test classes should get the repository instance from this class.
 */
public abstract class RepositoryProvider {
	/** Repository instance. */
	private static Repository repository;

	/**
	 * Set the repository instance.
	 * Clients should call this for configuration.
	 */
	public static void setRepository(Repository repository) {
		RepositoryProvider.repository = repository;
	}

	/**	Get the repository instance. */
	public static Repository getRepository() {
		return RepositoryProvider.repository;
	}
}
