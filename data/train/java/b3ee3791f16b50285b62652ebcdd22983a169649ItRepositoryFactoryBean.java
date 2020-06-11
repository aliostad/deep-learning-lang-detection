package com.itjenny.support.jpa;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.jpa.repository.support.LockModeRepositoryPostProcessor;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class ItRepositoryFactoryBean<T extends Repository<S, ID>, S, ID extends Serializable>
        extends JpaRepositoryFactoryBean<T, S, ID> {

    @Override
    protected RepositoryFactorySupport createRepositoryFactory(
            EntityManager entityManager) {
        return new ItCommonRepositoryFactory(entityManager);
    }

    protected static class ItCommonRepositoryFactory extends
            JpaRepositoryFactory {

        public ItCommonRepositoryFactory(EntityManager entityManager) {
            super(entityManager);
        }

        @Override
        @SuppressWarnings({ "unchecked", "rawtypes" })
        protected <T, ID extends Serializable> JpaRepository<?, ?> getTargetRepository(
                RepositoryMetadata metadata, EntityManager entityManager) {

            Class<?> repositoryInterface = metadata.getRepositoryInterface();

            if (!isItCommonRepository(repositoryInterface)) {
                return super.getTargetRepository(metadata, entityManager);
            }

            JpaEntityInformation<?, Serializable> entityInformation = getEntityInformation(metadata
                    .getDomainType());
            ItCommonRepositoryImpl<?, ?> repo = new ItCommonRepositoryImpl(
                    entityInformation, entityManager);
            repo.setLockMetadataProvider(LockModeRepositoryPostProcessor.INSTANCE
                    .getLockMetadataProvider());
            return repo;
        }

        @Override
        protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
            if (isItCommonRepository(metadata.getRepositoryInterface())) {
                return ItCommonRepositoryImpl.class;
            }
            return super.getRepositoryBaseClass(metadata);
        }

        protected boolean isItCommonRepository(Class<?> repositoryInterface) {

            return ItCommonRepository.class
                    .isAssignableFrom(repositoryInterface);
        }
    }
}
