package com.programmingspring.koans.service.scanned.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ServiceWithTwoConstructorDependencies implements MyService {

    private final MyRepository firstRepository;
    private final MyRepository secondRepository;

    @Autowired
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
