package org.simpleworkflow.repository.support;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.Repository;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class ExampleRepositoryFactoryBean<T extends Repository<S, ID>, S, ID extends Serializable>  extends JpaRepositoryFactoryBean<T, S, ID> {

  @Override
  protected RepositoryFactorySupport createRepositoryFactory(EntityManager entityManager) {
    return new ExampleRepositoryFactory(entityManager);
  }
  
}
