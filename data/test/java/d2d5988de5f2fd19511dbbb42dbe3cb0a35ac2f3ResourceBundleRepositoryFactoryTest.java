package com.benbarkay.fxi18n.repositories.resourcebundle;

import com.benbarkay.fxi18n.StringRepository;
import org.junit.Before;
import org.junit.Test;

import java.util.Locale;

import static org.junit.Assert.*;

public class ResourceBundleRepositoryFactoryTest {

    private ResourceBundleRepositoryFactory repositoryFactory;

    @Before
    public void setUp() {
        repositoryFactory = new ResourceBundleRepositoryFactory();
    }

    @Test
    public void itUsesDefaultResourceBundleWithNullLocale() {
        StringRepository repository = repositoryFactory.getRepository(getClass(), null);
        assertEquals("test", repository.getString("test"));
    }

    @Test
    public void itUsesGermanResourceBundleWithGermanLocale() {
        StringRepository repository = repositoryFactory.getRepository(getClass(), Locale.GERMAN);
        assertEquals("Test(german)", repository.getString("test"));
    }

}