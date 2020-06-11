package com.dstevens.persistence.auditing;


public abstract class AbstractAuditableRepository<E extends Auditable<E>> implements AuditableRepository<E> {

    private AuditableRepository<E> repository;

    public AbstractAuditableRepository(AuditableRepository<E> repository) {
        this.repository = repository;
    }
    
    public E create(E e) {
        return repository.create(e);
    }
    
    public E update(E e) {
        return repository.update(e);
    }
    
    public void delete(E e) {
        repository.delete(e);
    }
    
    public E undelete(E e) {
        return repository.undelete(e);
    }
    
    public void hardDelete(E e) {
        repository.hardDelete(e);
    }
    
}
