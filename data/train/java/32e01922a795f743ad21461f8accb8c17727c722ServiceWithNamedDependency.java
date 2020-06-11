package com.programmingspring.koans.service.scanned.spring;

import com.programmingspring.koans.repository.MyRepository;
import com.programmingspring.koans.service.MyService;
import org.springframework.context.annotation.Scope;

@Scope("prototype")
public class ServiceWithNamedDependency implements MyService {

    private MyRepository repository;

    public MyRepository getRepository() {
        return repository;
    }

    public void setRepository(MyRepository repository) {
        this.repository = repository;
    }
}
