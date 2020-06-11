package com.github.saden1.hk2testng.service.impl;

import com.github.saden1.hk2testng.service.NamedService;
import com.github.saden1.hk2testng.service.SecondaryService;
import javax.inject.Inject;
import javax.inject.Named;
import org.jvnet.hk2.annotations.Service;

@Named("namedService")
@Service
public class NamedServiceImpl implements NamedService {

    private final SecondaryService secondaryService;

    @Inject
    NamedServiceImpl(SecondaryService secondaryService) {
        this.secondaryService = secondaryService;
    }

    public SecondaryService getSecondaryService() {
        return secondaryService;
    }

}
