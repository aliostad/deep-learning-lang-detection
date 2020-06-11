package com.bioaba.taskmanager.core.service.base;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public abstract class AbstractCrudService<T> {

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

	public T save( T entity){
		repository.saveAndFlush(entity);
		return entity;
	}
	
	public void delete(T entity){
		repository.delete(entity);
	}
	
	public void delete(Long entity){
		repository.delete(entity);
	}
}
