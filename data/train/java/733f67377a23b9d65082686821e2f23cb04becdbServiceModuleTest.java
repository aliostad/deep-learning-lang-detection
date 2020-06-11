package com.thoughtworks.yak;

import org.junit.Test;

import static org.hamcrest.CoreMatchers.nullValue;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThat;

public class ServiceModuleTest {
    @Test
    public void shouldBeAbleToGetAddedService() throws Exception {
        ServiceModule serviceModule = new ServiceModule() {
            @Override
            protected void configure() {
                addService(TestService.class).implementedBy(TestServiceProvider.class);
            }
        };

        serviceModule.initialize();
        ServiceDefinition<TestService> serviceDefinition = serviceModule.getService(TestService.class, null);
        assertEquals(serviceDefinition.getServiceProvider(), TestServiceProvider.class);
    }

    @Test
    public void shouldNotGetServiceBeforeInitialize() throws Exception {
        ServiceModule serviceModule = new ServiceModule() {
            @Override
            protected void configure() {
                addService(TestService.class).implementedBy(TestServiceProvider.class);
            }
        };

        ServiceDefinition<TestService> serviceDefinition = serviceModule.getService(TestService.class, null);
        assertThat(serviceDefinition, nullValue());
    }

    public interface TestService {
    }

    public static class TestServiceProvider implements TestService {
    }
}
