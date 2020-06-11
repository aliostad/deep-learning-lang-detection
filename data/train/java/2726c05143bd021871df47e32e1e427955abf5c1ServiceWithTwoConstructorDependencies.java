package com.programmingspring.koans.service.scanned.jsr330;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;

import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;

@Named
@Singleton
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
