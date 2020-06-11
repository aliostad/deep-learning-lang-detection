package com.programmingspring.koans.service.explicit.jsr330;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;

import javax.inject.Inject;
import javax.inject.Named;

public class ServiceWithTwoNamedConstructorDependencies implements MyService {

    private final MyRepository firstRepository;
    private final MyRepository secondRepository;

    @Inject
    public ServiceWithTwoNamedConstructorDependencies(@Named("firstRepository") MyRepository repoOne, @Named("secondRepository") MyRepository repoTwo) {
        this.firstRepository = repoOne;
        this.secondRepository = repoTwo;
    }

    public MyRepository getRepository() {
        return firstRepository;
    }

    public MyRepository getSecondRepository() {
        return secondRepository;
    }
}
