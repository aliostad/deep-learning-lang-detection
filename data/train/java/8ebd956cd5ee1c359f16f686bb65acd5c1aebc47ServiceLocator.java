package cz.vvalko.sampleproject.application.services;

import cz.vvalko.sampleproject.catalogue.services.CategoryService;
import cz.vvalko.sampleproject.catalogue.services.CategoryServiceImpl;

/**
 * User: VVALKO
 * Date: 27.4.15
 */
public class ServiceLocator {
    private static ServiceLocator instance = new ServiceLocator();
    private CategoryService categoryService;

    public static ServiceLocator getInstance() {
        return instance;
    }

    public synchronized CategoryService getCategoryService() {
        if (categoryService == null) {
            CategoryServiceImpl service = new CategoryServiceImpl();
            service.initialize();
            categoryService = service;
        }
        return categoryService;
    }

}
