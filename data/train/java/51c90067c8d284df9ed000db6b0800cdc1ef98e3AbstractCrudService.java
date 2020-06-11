package com.bioaba.springteste.core.service.base;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.bioaba.springteste.persistence.entity.base.AbstractEntity;


public abstract class AbstractCrudService<T extends AbstractEntity> {

	private JpaRepository<T, Long> repository;

	protected JpaRepository<T, Long> getRepository() {
		return repository;
	}

	public AbstractCrudService(JpaRepository<T, Long> repository) {
		this.repository = repository;
	}

	public List<T> list() {
		return repository.findAll();
	}

}
