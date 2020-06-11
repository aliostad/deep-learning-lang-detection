package com.sdjz.jpaRepository;

import java.io.Serializable;

import javax.persistence.EntityManager;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.support.JpaRepositoryFactoryBean;
import org.springframework.data.repository.core.support.RepositoryFactorySupport;

public class MyRepositoryFactoryBean<T extends JpaRepository<Object,Serializable>> extends JpaRepositoryFactoryBean<T,Object,Serializable> {
	protected RepositoryFactorySupport createRepositoryFactory(EntityManager em){
		return new MyRepositoryFactory(em);
	}

}
