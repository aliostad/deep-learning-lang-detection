package de.freund.sam.services;

import de.freund.sam.services.api.GitService;
import de.freund.sam.services.api.PersistenceService;
import de.freund.sam.services.api.SamService;

// TODO: Auto-generated Javadoc
/**
 * The Class SamServiceRegistry.
 */
public class SamServiceRegistry {

	/** The instance. */
	private static SamServiceRegistry instance;

	/** The persistence service. */
	private PersistenceService persistenceService;
	
	/** The git service. */
	private GitService gitService;
	
	/** The sam service. */
	private SamService samService;

	/**
	 * Instantiates a new sam service registry.
	 */
	private SamServiceRegistry() {

	}

	/**
	 * Gets the single instance of SamServiceRegistry.
	 *
	 * @return single instance of SamServiceRegistry
	 */
	public static SamServiceRegistry getInstance() {
		if (instance == null) {
			instance = new SamServiceRegistry();
		}

		return instance;
	}

	/**
	 * Register git service.
	 *
	 * @param gitService the git service
	 */
	public void registerGitService(GitService gitService) {
		this.gitService = gitService;
	}

	/**
	 * Register sam service.
	 *
	 * @param samService the sam service
	 */
	public void registerSamService(SamService samService) {
		this.samService = samService;
	}

	/**
	 * Register persistence service.
	 *
	 * @param persistenceService the persistence service
	 */
	public void registerPersistenceService(PersistenceService persistenceService) {
		this.persistenceService = persistenceService;
	}

	/**
	 * Gets the git service.
	 *
	 * @return the git service
	 */
	public GitService getGitService() {
		return gitService;
	}

	/**
	 * Gets the sam service.
	 *
	 * @return the sam service
	 */
	public SamService getSamService() {
		return samService;
	}

	/**
	 * Gets the persistence service.
	 *
	 * @return the persistence service
	 */
	public PersistenceService getPersistenceService() {
		return persistenceService;
	}
}
