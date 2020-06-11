package com.mywork.framework.spring.helper;


import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryInformation;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

import com.mywork.framework.jpa.repository.BaseRepository;

public class BaseRepositoryFactoryBean<R extends JpaRepository<T, I>, T, I extends Serializable>
        extends JpaRepositoryFactoryBean<R, T, I> {

    protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
        return new BaseRepositoryFactory(entityManager);
    }

    private static class BaseRepositoryFactory<T, I extends Serializable> extends JpaRepositoryFactory {
        private EntityManager entityManager;

        public BaseRepositoryFactory(EntityManager entityManager) {
            super(entityManager);
            this.entityManager = entityManager;
        }

        @SuppressWarnings("unchecked")
        protected Object getTargetRepository(RepositoryInformation information) {
            Class<?> repositoryInterface = information.getRepositoryInterface();
            if (isBaseRepositoryInterface(repositoryInterface)) {
                return new SimpleBaseRepository<T, I>(
                        (JpaEntityInformation<T, I>) getEntityInformation(information.getDomainType()), entityManager);
            } else {
                return super.getTargetRepository(information);
            }
        }

        protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
            if (isBaseRepositoryInterface(metadata.getRepositoryInterface())) {
                return BaseRepository.class;
            } else {
                return super.getRepositoryBaseClass(metadata);
            }
        }

        private boolean isBaseRepositoryInterface(Class<?> repositoryInterface) {
            return BaseRepository.class.isAssignableFrom(repositoryInterface);
        }
    }
}
