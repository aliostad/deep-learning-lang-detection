package cz.cuni.mff.odcleanstore.fusiontool.util;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryException;

public class CloseableRepository implements AutoCloseable {
    private final Repository repository;

    public CloseableRepository(Repository repository) {
        this.repository = repository;
    }

    public Repository get() {
        return repository;
    }

    @Override
    public void close() throws RepositoryException {
        repository.shutDown();
    }
}
