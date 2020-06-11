package com.forum.service;

import com.forum.domain.Advice;
import com.forum.repository.AdviceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdviceService {

    private AdviceRepository adviceRepository;

    @Autowired
    public AdviceService(AdviceRepository adviceRepository) {
        this.adviceRepository = adviceRepository;
    }

    public int save(Advice advice) {
        return adviceRepository.save(advice);
    }
}
