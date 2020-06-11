package com.page5of4.codon.useful.spring.config;

import org.springframework.beans.factory.FactoryBean;

import com.page5of4.codon.useful.repositories.Repositories;
import com.page5of4.codon.useful.repositories.Repository;
import com.page5of4.codon.useful.repositories.RepositoryFactory;

public class RepositoryFactoryBean implements FactoryBean<Repository<?, ?>> {
   private final RepositoryFactory repositoryFactory;
   private Class<? extends Repository<?, ?>> repositoryClass;

   public Class<? extends Repository<?, ?>> getRepositoryClass() {
      return repositoryClass;
   }

   public void setRepositoryClass(Class<? extends Repository<?, ?>> repositoryClass) {
      this.repositoryClass = repositoryClass;
   }

   public RepositoryFactoryBean(RepositoryFactory repositoryFactory) {
      super();
      this.repositoryFactory = repositoryFactory;
   }

   @Override
   public Repository<?, ?> getObject() throws Exception {
      return Repositories.create(repositoryClass, repositoryFactory);
   }

   @Override
   public Class<?> getObjectType() {
      return repositoryClass;
   }

   @Override
   public boolean isSingleton() {
      return true;
   }
}