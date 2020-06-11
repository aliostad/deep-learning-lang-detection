package com.buswe.base.dao.springdata;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import org.springframework.data.repository.core.RepositoryMetadata;

public class BaseRepositoryFactory
  extends JpaRepositoryFactory
{
  public BaseRepositoryFactory(EntityManager entityManager)
  {
    super(entityManager);
  }
  
  protected SimpleJpaRepository<?, ?> getTargetRepository(RepositoryMetadata metadata, EntityManager em)
  {
    return new BaseRepositoryImpl(metadata.getDomainType(), em);
  }
  
  protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata)
  {
    return BaseRepositoryImpl.class;
  }
}
