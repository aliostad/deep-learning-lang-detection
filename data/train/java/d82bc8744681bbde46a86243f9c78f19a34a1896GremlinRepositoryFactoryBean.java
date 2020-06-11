package com.mamu.repository.support;

import org.springframework.beans.factory.annotation.Autowired;
import com.mamu.repository.core.GremlinRepository;
import com.mamu.repository.core.GremlinRepositoryContext;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.data.repository.core.support.TransactionalRepositoryFactoryBeanSupport;

/**
 * Special adapter for Springs {@link org.springframework.beans.factory.FactoryBean} interface to allow easy setup of
 * repository factories via Spring configuration.
 *
 * @param <T> the type of the repository
 * @param <S> the type of the entity
 * @author Johnny
 */
public class GremlinRepositoryFactoryBean<T extends GremlinRepository<S>, S> extends TransactionalRepositoryFactoryBeanSupport<T, S, String> {

    /** The orient operations. */
    @Autowired
    private GremlinRepositoryContext context;

    public GremlinRepositoryFactoryBean() {
    }

    /* (non-Javadoc)
         * @see org.springframework.data.repository.core.support.TransactionalRepositoryFactoryBeanSupport#doCreateRepositoryFactory()
         */
    @Override
    protected RepositoryFactorySupport doCreateRepositoryFactory() {
        return new GremlinRepositoryFactory(context);
    }
}
