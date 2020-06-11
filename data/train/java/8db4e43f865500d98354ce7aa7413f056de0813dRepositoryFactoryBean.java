package com.ykh.dao.suport;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

import javax.persistence.EntityManager;
import java.io.Serializable;

/**
 * Created by ant_shake_tree on 15/7/25.
 */
public class RepositoryFactoryBean<R extends JpaRepository<T, I>, T,
        I extends Serializable> extends JpaRepositoryFactoryBean<R, T, I> {


    protected RepositoryFactorySupport createRepositoryFactory(EntityManager em) {
        return new MyRepositoryFactory(em);
    }

    private static class MyRepositoryFactory<T, I extends Serializable>
            extends JpaRepositoryFactory {
        private final EntityManager em;

        public MyRepositoryFactory(EntityManager em) {
            super(em);
            this.em = em;
        }

        protected Object getTargetRepository(RepositoryMetadata metadata) {
            return new DaoSupport<T, I>((Class<T>) metadata.getDomainType(), em);
        }

        protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
            return DaoSupport.class;
        }
    }
}
