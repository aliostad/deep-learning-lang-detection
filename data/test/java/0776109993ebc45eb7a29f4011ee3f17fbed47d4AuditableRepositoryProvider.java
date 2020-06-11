package com.dstevens.persistence.auditing;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.dstevens.suppliers.ClockSupplier;

@Repository
public class AuditableRepositoryProvider {

    private final AuditEventRepository auditableRepository;
    private final ClockSupplier clockSupplier;

    @Autowired
    public AuditableRepositoryProvider(AuditEventRepository auditableRepository, ClockSupplier clockSupplier) {
        this.auditableRepository = auditableRepository;
        this.clockSupplier = clockSupplier;
    }
    
    public <E extends Auditable<E>> AuditableRepository<E> repositoryFor(CrudRepository<E, String> dao) {
        return new AuditableRepositoryImpl<>(dao, auditableRepository, clockSupplier);
    }
    
}
