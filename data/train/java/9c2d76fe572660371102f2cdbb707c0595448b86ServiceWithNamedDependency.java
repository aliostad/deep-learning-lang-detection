package com.programmingspring.koans.service.scanned.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ServiceWithNamedDependency implements MyService {

    private MyRepository repository;

    public MyRepository getRepository() {
        return repository;
    }

    @Autowired
    @Qualifier("firstRepository")
    public void setRepository(MyRepository repository) {
        this.repository = repository;
    }
}
