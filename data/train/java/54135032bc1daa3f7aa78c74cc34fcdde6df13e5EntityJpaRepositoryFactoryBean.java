package com.atomrain.data.repository;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

import javax.persistence.EntityManager;
import java.io.Serializable;

/**
 * Factory bean that must be used for generating the {@link EntityJpaRepository} repository.
 *
 * @author bradnussbaum
 * @version 1.0.0
 * @since 1.0.0
 */
public class EntityJpaRepositoryFactoryBean<T extends Repository<S, ID>, S, ID extends Serializable> extends
        JpaRepositoryFactoryBean<T, S, ID> {

    /**
     * Returns a {@link RepositoryFactorySupport}.
     *
     * @param entityManager
     * @return
     */
    protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
        return new EntityJpaRepositoryFactory<T, ID>(entityManager);
    }

}
