package com.autentia.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.autentia.demo.repository.SampleRepository;

@Service
public class SampleService {

    @Autowired
    private SampleRepository sampleRepository;

    public SampleService(SampleRepository sampleRepository) {
        this.sampleRepository = sampleRepository;
    }

    public String welcome(String nodo) {
        return sampleRepository.getMessageByNodo(nodo);
    }

}
