package com.earldouglas.dbencryption;

import org.springframework.transaction.annotation.Transactional;

@Transactional
public class TransactionalHibernateRepository implements Repository {

	private HibernateRepository hibernateRepository;

	public void setHibernateRepository(HibernateRepository hibernateRepository) {
		this.hibernateRepository = hibernateRepository;
	}

	@Override
	public Object retrieve(Class<?> entityClass, String identifier) {
		return hibernateRepository.retrieve(entityClass, identifier);
	}

	@Override
	public void store(Object entity) {
		hibernateRepository.store(entity);
	}
}
