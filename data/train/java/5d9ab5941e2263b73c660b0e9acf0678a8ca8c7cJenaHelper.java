package com.mysema.rdfbean;

import com.mysema.rdfbean.jena.MemoryRepository;
import com.mysema.rdfbean.model.Repository;
import com.mysema.rdfbean.model.UID;

public class JenaHelper extends Helper {

    @Override
    public Repository createRepository() {
        MemoryRepository repository = new MemoryRepository();
        repository.addGraph(new UID(TEST.NS));
        repository.addGraph(new UID("http://ex1.com"));
        repository.addGraph(new UID("http://ex2.com"));
        repository.addGraph(new UID("http://example.com"));
        return repository;
    }

}
