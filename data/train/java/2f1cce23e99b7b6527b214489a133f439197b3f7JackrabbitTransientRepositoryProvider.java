package org.xwiki.store.jcr.internal;

import javax.jcr.Repository;

import org.apache.jackrabbit.core.TransientRepository;
import org.xwiki.component.phase.Initializable;
import org.xwiki.component.phase.InitializationException;
import org.xwiki.store.jcr.RepositoryProvider;

/**
 * works without configuration. good for testing.
 */
public class JackrabbitTransientRepositoryProvider implements RepositoryProvider, Initializable
{
    protected TransientRepository repository;

    public Repository getRepository()
    {
        return repository;
    }

    public void initialize() throws InitializationException
    {
        try {
            repository = new TransientRepository("target/repository.xml", "target/repository");
        } catch (Exception e) {
            throw new InitializationException("Can't initialize jcr repository", e);
        }
    }

    public void shutdown()
    {
        repository.shutdown();
    }
}
