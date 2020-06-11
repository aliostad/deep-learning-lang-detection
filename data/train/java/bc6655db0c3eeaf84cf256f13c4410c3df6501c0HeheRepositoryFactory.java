package org.cl.hehe.support.repository;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.data.repository.core.RepositoryMetadata;

/**
 * Created by yongzhi.zhang on 14-1-1.
 */
public class HeheRepositoryFactory extends JpaRepositoryFactory {

    /**
     * @param entityManager
     */
    public HeheRepositoryFactory(EntityManager entityManager) {
        super(entityManager);
    }

    /**
     * @see org.springframework.data.jpa.repository.support.JpaRepositoryFactory#getTargetRepository(org.springframework.data.repository.core.RepositoryMetadata, javax.persistence.EntityManager)
     */
    @Override
    protected <T, ID extends Serializable> SimpleJpaRepository<?, ?> getTargetRepository(RepositoryMetadata metadata,
                                                                                         EntityManager entityManager) {
        Class<?> repositoryInterface = metadata.getRepositoryInterface();
        JpaEntityInformation<?, Serializable> entityInformation = getEntityInformation(metadata.getDomainType());

        if (JpaRepository.class.isAssignableFrom(repositoryInterface)) {
            SimpleJpaRepository<?, ?> repo = new HeheCustomRepository(entityInformation, entityManager);
            return repo;
        }
        return super.getTargetRepository(metadata, entityManager);
    }

    /**
     * @see org.springframework.data.jpa.repository.support.JpaRepositoryFactory#getRepositoryBaseClass(org.springframework.data.repository.core.RepositoryMetadata)
     */
    @Override
    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
        return HeheCustomRepository.class;
    }

}