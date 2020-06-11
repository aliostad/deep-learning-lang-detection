/**
 * 
 */
package org.zhubao.boot.service.base;

import java.io.Serializable;

import org.zhubao.boot.repository.base.BaseRepository;

/**
 * 
 * @author jason.zhu
 *
 */
public class BaseServiceImpl<T, K extends Serializable> implements BaseService<T, K> {

    protected BaseRepository<T, K> repository;

    public void save(T t) {
        repository.save(t);
    }

    public void update(T t) {
        repository.save(t);
    }

    public void delete(T t) {
        repository.delete(t);
    }

    public T findById(K id) {
        return repository.findOne(id);
    }
    
    public Iterable<T> findAll() {
        return repository.findAll();
    }

    public BaseRepository<T, K> getRepository() {
        return repository;
    }

    public void setRepository(BaseRepository<T, K> repository) {
        this.repository = repository;
    }

}
