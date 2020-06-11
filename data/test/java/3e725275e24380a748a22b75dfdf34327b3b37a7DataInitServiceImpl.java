package ar.com.hexacta.tpl.service.impl;

import org.springframework.transaction.annotation.Transactional;

import ar.com.hexacta.tpl.persistence.repository.DataInitRepository;
import ar.com.hexacta.tpl.service.IDataInitService;

public class DataInitServiceImpl implements IDataInitService {

    private DataInitRepository repository;

    @Override
    @Transactional
    public boolean initializeData() {
        return this.getRepository().initializeData();
    }

    public void setRepository(final DataInitRepository repository) {
        this.repository = repository;
    }

    public DataInitRepository getRepository() {
        return repository;
    }

}
