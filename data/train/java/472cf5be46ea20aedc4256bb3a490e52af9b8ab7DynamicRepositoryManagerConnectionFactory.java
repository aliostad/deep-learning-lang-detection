package org.openrdf.spring;

import org.openrdf.repository.Repository;
import org.openrdf.repository.RepositoryConnection;
import org.openrdf.repository.RepositoryException;
import org.openrdf.repository.config.RepositoryConfig;
import org.openrdf.repository.config.RepositoryConfigException;
import org.openrdf.repository.config.RepositoryImplConfig;
import org.openrdf.repository.manager.RepositoryManager;
import org.springframework.beans.factory.DisposableBean;

import java.util.HashMap;
import java.util.Map;

/**
 * <p>{@link RepositoryManagerConnectionFactory} handles connections to a multiple corresponding
 * {@link org.openrdf.repository.Repository}s managed by a {@link org.openrdf.repository.manager.RepositoryManager}
 * and manages the transaction state (represented by {@link SesameTransactionObject}).</p>
 *
 * @author ameingast@gmail.com
 */
public class DynamicRepositoryManagerConnectionFactory implements SesameConnectionFactory, DisposableBean {
    private final RepositoryManager repositoryManager;

    private final RepositoryIdProvider repositoryIdProvider;

    private final RepositoryImplConfig repositoryImplConfig;

    private final Map<String, RepositoryConnectionFactory> repositoryConnectionFactoryMap;

    /**
     * <p>Creates a new {@link DynamicRepositoryManagerConnectionFactory} for the {@link org.openrdf.repository.Repository}
     * identified by the provided {@link org.openrdf.spring.DynamicRepositoryManagerConnectionFactory.RepositoryIdProvider}
     * in the {@link RepositoryManager} <code>repositoryManager</code>.</p>
     * <p/>
     * <p>For example, a <code>repositoryIdProvider</code> that fetches IDs based on a thread-local, user-specific variable
     * can be used to create <i>dynamic</i> repositories for multiple users.</p>
     *
     * @param repositoryManager    The {@link RepositoryManager} that holds the {@link org.openrdf.repository.Repository} to which connections
     *                             will be opened.
     * @param repositoryIdProvider The id of the {@link org.openrdf.repository.Repository} which is used by the {@link RepositoryManager} to
     *                             identify the {@link org.openrdf.repository.Repository} to which connections will be opened is retrieved
     *                             from via a call-back from <code>repositoryIdProvider</code>.
     */
    DynamicRepositoryManagerConnectionFactory(RepositoryManager repositoryManager,
                                              RepositoryIdProvider repositoryIdProvider) {
        this(repositoryManager, null, repositoryIdProvider);
    }

    DynamicRepositoryManagerConnectionFactory(RepositoryManager repositoryManager,
                                              RepositoryImplConfig repositoryImplConfig,
                                              RepositoryIdProvider repositoryIdProvider) {
        this.repositoryManager = repositoryManager;
        this.repositoryImplConfig = repositoryImplConfig;
        this.repositoryIdProvider = repositoryIdProvider;
        this.repositoryConnectionFactoryMap = new HashMap<>(128);
    }

    /**
     * @inheritDoc
     */
    @Override
    public RepositoryConnection getConnection() {
        return getRepositoryConnectionFactory().getConnection();
    }

    /**
     * @inheritDoc
     */
    @Override
    public void closeConnection() {
        getRepositoryConnectionFactory().closeConnection();
    }

    /**
     * @inheritDoc
     */
    @Override
    public SesameTransactionObject createTransaction() throws RepositoryException {
        return getRepositoryConnectionFactory().createTransaction();
    }

    /**
     * @inheritDoc
     */
    @Override
    public void endTransaction(boolean rollback) throws RepositoryException {
        getRepositoryConnectionFactory().endTransaction(rollback);
    }

    /**
     * @inheritDoc
     */
    @Override
    public SesameTransactionObject getLocalTransactionObject() {
        return getRepositoryConnectionFactory().getLocalTransactionObject();
    }

    private synchronized RepositoryConnectionFactory getRepositoryConnectionFactory() {
        String repositoryId = repositoryIdProvider.getRepositoryId();
        RepositoryConnectionFactory repositoryConnectionFactory = repositoryConnectionFactoryMap.get(repositoryId);

        if (repositoryConnectionFactory == null) {
            repositoryConnectionFactory = initializeRepositoryConnectionFactory(repositoryId);
            repositoryConnectionFactoryMap.put(repositoryId, repositoryConnectionFactory);
        }

        return repositoryConnectionFactory;
    }

    private RepositoryConnectionFactory initializeRepositoryConnectionFactory(String repositoryId) {
        try {
            Repository repository = repositoryManager.getRepository(repositoryId);

            if (repository == null) {
                if (repositoryImplConfig != null) {
                    RepositoryConfig repositoryConfig = new RepositoryConfig(repositoryId, repositoryImplConfig);

                    repositoryManager.addRepositoryConfig(repositoryConfig);
                    repository = repositoryManager.getRepository(repositoryId);
                } else {
                    throw new SesameTransactionException("No such repository: " + repositoryId);
                }
            }

            return new RepositoryConnectionFactory(repository);
        } catch (RepositoryException | RepositoryConfigException e) {
            throw new SesameTransactionException(e);
        }
    }

    /**
     * <p>Shuts down the associated {@link Repository}s if they were initialized before and resets the
     * state of the object.</p>
     *
     * @throws Exception {@see Repository#shutDown}
     */
    @Override
    public void destroy() throws Exception {
        for (RepositoryConnectionFactory repositoryConnectionFactory : repositoryConnectionFactoryMap.values()) {
            repositoryConnectionFactory.destroy();
        }

        repositoryConnectionFactoryMap.clear();
    }

    @Override
    public String toString() {
        return "DynamicRepositoryManagerConnectionFactory{" +
                "repositoryManager=" + repositoryManager +
                ", repositoryIdProvider=" + repositoryIdProvider +
                ", repositoryImplConfig=" + repositoryImplConfig +
                ", repositoryConnectionFactoryMap=" + repositoryConnectionFactoryMap +
                '}';
    }

    /**
     * Call-back helper to provide runtime-dynamic repository-ids for
     * {@link org.openrdf.spring.DynamicRepositoryManagerConnectionFactory}.
     */
    public interface RepositoryIdProvider {
        String getRepositoryId();
    }
}
