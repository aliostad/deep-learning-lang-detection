package com.programmingspring.koans.service.explicit.jsr330;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;

import javax.inject.Inject;

public class ServiceWithConstructorDependency implements MyService {

    private final MyRepository repository;

    @Inject
    public ServiceWithConstructorDependency(MyRepository repository) {
        this.repository = repository;
    }

    public MyRepository getRepository() {
        return repository;
    }
}
