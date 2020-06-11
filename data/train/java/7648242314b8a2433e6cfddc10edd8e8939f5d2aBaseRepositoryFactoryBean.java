package com.datamodelling.store.repository.base;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactory;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class BaseRepositoryFactoryBean<R extends JpaRepository<T, I>, T, I extends Serializable> extends
    JpaRepositoryFactoryBean<R, T, I> {
  
  protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager)
  {
    return new BaseRepositoryFactory(entityManager);
  }
  
  private static class BaseRepositoryFactory<T, I extends Serializable> extends JpaRepositoryFactory {
    
    private EntityManager entityManager;
    
    public BaseRepositoryFactory(EntityManager entityManager)
    {
      super(entityManager);
      this.entityManager = entityManager;
    }
    
    protected Object getTargetRepository(RepositoryMetadata metadata)
    {
      return new BaseRepositoryImpl<T, I>((Class<T>) metadata.getDomainType(), entityManager);
    }
    
    protected Class<?> getRepositoryBaseClass(RepositoryMetadata metadata)
    {
      return IBaseRepository.class;
    }
  }
}
