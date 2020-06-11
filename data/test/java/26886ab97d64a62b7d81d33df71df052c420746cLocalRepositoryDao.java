package co.codewizards.cloudstore.local.persistence;

import java.util.Iterator;

public class LocalRepositoryDao extends Dao<LocalRepository, LocalRepositoryDao> {

	public LocalRepository getLocalRepositoryOrFail() {
		Iterator<LocalRepository> repositoryIterator = pm().getExtent(LocalRepository.class).iterator();
		if (!repositoryIterator.hasNext()) {
			throw new IllegalStateException("LocalRepository entity not found in database.");
		}
		LocalRepository localRepository = repositoryIterator.next();
		if (repositoryIterator.hasNext()) {
			throw new IllegalStateException("Multiple LocalRepository entities in database.");
		}
		return localRepository;
	}

}
