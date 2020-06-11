package org.ojqa.service.impl;

import java.util.List;

import org.ojqa.domain.repository.Repository;
import org.ojqa.service.BaseService;

/**
 * Base Service, all other service should extend from this class.
 * 
 * @author ybak
 * 
 * @param <T>
 */
public class BaseServiceImpl<T> implements BaseService<T> {

    private Repository<T> repository;

    public void delete(T entity) {
        repository.delete(entity);
    }

    public void delete(Long id) {
        repository.delete(id);

    }

    public T get(Long id) {
        return repository.find(id);
    }

    public List<T> getAll() {
        return repository.findAll();
    }

    public void save(T transientEntity) {
        repository.save(transientEntity);
    }

    public Repository<T> getRepository() {
        return repository;
    }

    public void setRepository(Repository<T> pRepository) {
        this.repository = pRepository;
    }
}
