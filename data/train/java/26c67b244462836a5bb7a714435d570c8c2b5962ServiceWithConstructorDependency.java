package com.programmingspring.koans.service.explicit.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.beans.factory.annotation.Autowired;

public class ServiceWithConstructorDependency implements MyService {

    private final MyRepository repository;

    @Autowired
    public ServiceWithConstructorDependency(MyRepository repository) {
        this.repository = repository;
    }

    public MyRepository getRepository() {
        return repository;
    }
}
