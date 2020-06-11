package com.programmingspring.koans.service.explicit.jsr330;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;

import javax.inject.Inject;

public class ServiceWithTwoConstructorDependencies implements MyService {

    private final MyRepository firstRepository;
    private final MyRepository secondRepository;

    @Inject
    public ServiceWithTwoConstructorDependencies(MyRepository firstRepository, MyRepository secondRepository) {
        this.firstRepository = firstRepository;
        this.secondRepository = secondRepository;
    }

    public MyRepository getRepository() {
        return firstRepository;
    }

    public MyRepository getSecondRepository() {
        return secondRepository;
    }
}
