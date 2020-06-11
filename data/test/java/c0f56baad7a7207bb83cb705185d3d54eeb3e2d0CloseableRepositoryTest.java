package cz.cuni.mff.odcleanstore.fusiontool.util;

import org.junit.Test;
import org.openrdf.repository.Repository;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;

public class CloseableRepositoryTest {
    @Test
    public void shutsDownRepository() throws Exception {
        Repository repository = mock(Repository.class);
        CloseableRepository closeableRepository = new CloseableRepository(repository);
        closeableRepository.close();

        verify(repository).shutDown();
    }
}