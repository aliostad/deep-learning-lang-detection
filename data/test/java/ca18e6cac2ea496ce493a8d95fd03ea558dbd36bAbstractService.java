package org.cloudme.webgallery.service;

import java.util.Collection;

import org.cloudme.webgallery.model.IdObject;
import org.cloudme.webgallery.persistence.Repository;

public abstract class AbstractService<K, T extends IdObject<K>, R extends Repository<K, T>> {
    protected R repository;
    
    protected AbstractService(R repository) {
        this.repository = repository;
    }

    public void setRepository(R repository) {
        this.repository = repository;
    }

    public Collection<T> findAll() {
        return repository.findAll();
    }

    public T find(K id) {
        return repository.find(id);
    }

    public void save(T t) {
        repository.save(t);
    }

    public void delete(K id) {
        repository.delete(id);
    }
}
