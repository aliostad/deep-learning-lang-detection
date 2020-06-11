package com.github.saden1.hk2testng.service.provider;

import com.github.saden1.hk2testng.service.ProvidedService;
import com.github.saden1.hk2testng.service.SecondaryService;

/**
 *
 * @author saden
 */
public class ProvidedServiceImpl implements ProvidedService {

    private final SecondaryService secondaryService;

    ProvidedServiceImpl(SecondaryService secondaryService) {
        this.secondaryService = secondaryService;
    }

    @Override
    public SecondaryService getSecondaryService() {
        return secondaryService;
    }
}
