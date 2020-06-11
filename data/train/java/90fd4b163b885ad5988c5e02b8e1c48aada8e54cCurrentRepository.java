package kr.re.ec.grigit;

import org.eclipse.jgit.lib.Repository;

/**
 */
public class CurrentRepository {

	// for singleton
	private static CurrentRepository instance = null;

	// for singleton
	static {
		try {
			instance = new CurrentRepository();
		} catch (Exception e) {
			throw new RuntimeException("singleton instance intialize error");
		}
	}

	// for singleton
	private CurrentRepository() {

	}

	// for singleton
	/**
	 * Method getInstance.
	 * @return CurrentRepository
	 */
	public static CurrentRepository getInstance() {
		return instance;
	}

	private Repository repository;

	/**
	 * Method getRepository.
	 * @return Repository
	 */
	public Repository getRepository() {
		return repository;
	}

	/**
	 * Method setRepository.
	 * @param repository Repository
	 */
	public void setRepository(Repository repository) {
		this.repository = repository;
	}

}
