/**
 * Copyright (c) 2005-2012 https://github.com/zhangkaitao
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 */
package com.base.repository.support;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;
import org.springframework.data.repository.query.QueryLookupStrategy;
import com.base.repository.BaseRepository;
import javax.persistence.EntityManager;
import java.io.Serializable;

/**
 * 基础Repostory简单实现 factory bean
 * 请参考 spring-data-jpa-reference [1.4.2. Adding custom behaviour to all repositories]
 * <p>User: Zhang Kaitao
 * <p>Date: 13-5-5 上午11:57
 * <p>Version: 1.0
 */
public class SimpleBaseRepositoryFactoryBean<R extends JpaRepository<M, ID>, M, ID extends Serializable>
        extends JpaRepositoryFactoryBean<R, M, ID> {

    public SimpleBaseRepositoryFactoryBean() {
    }

    protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
        return new SimpleBaseRepositoryFactory(entityManager);
    }
}

class SimpleBaseRepositoryFactory<M, ID extends Serializable> extends JpaRepositoryFactory {

    private EntityManager entityManager;

    public SimpleBaseRepositoryFactory(EntityManager entityManager) {
        super(entityManager);
        this.entityManager = entityManager;
    }

    protected Object getTargetRepository(RepositoryMetadata metadata) {
        Class<?> repositoryInterface = metadata.getRepositoryInterface();

        if (isBaseRepository(repositoryInterface)) {

            JpaEntityInformation<M, ID> entityInformation = getEntityInformation((Class<M>) metadata.getDomainType());
            SimpleBaseRepository repository = new SimpleBaseRepository<M, ID>(entityInformation, entityManager);
            return repository;
        }
        return super.getTargetRepository(metadata);
    }

    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata) {
        if (isBaseRepository(metadata.getRepositoryInterface())) {
            return SimpleBaseRepository.class;
        }
        return super.getRepositoryBaseClass(metadata);
    }

    private boolean isBaseRepository(Class<?> repositoryInterface) {
        return BaseRepository.class.isAssignableFrom(repositoryInterface);
    }

    @Override
    protected QueryLookupStrategy getQueryLookupStrategy(QueryLookupStrategy.Key key) {
        return super.getQueryLookupStrategy(key);
    }
}
