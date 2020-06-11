package com.programmingspring.koans.service.scanned.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

@Service
public class ServiceWithTwoNamedConstructorDependencies implements MyService {

    private final MyRepository firstRepository;
    private final MyRepository secondRepository;

    @Autowired
    public ServiceWithTwoNamedConstructorDependencies(@Qualifier("firstRepository") MyRepository repoOne, @Qualifier("secondRepository") MyRepository repoTwo) {
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
