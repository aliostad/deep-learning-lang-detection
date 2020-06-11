package com.programmingspring.koans.service.explicit.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

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
