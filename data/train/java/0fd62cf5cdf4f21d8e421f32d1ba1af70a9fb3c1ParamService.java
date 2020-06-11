package com.demien.sboot.service;

import com.demien.sboot.domain.Param;
import com.demien.sboot.repository.ParamRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ParamService extends AbstractService<Param, Long> {

    private ParamRepository paramRepository;

    @Autowired
    public ParamService(ParamRepository paramRepository) {
        super(paramRepository);
        this.paramRepository=paramRepository;

    }

}
