package org.iglootools.commons.handlerregistry;

import static org.mockito.Mockito.mock;

import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableSet;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class DefaultHandlerRegistryTest {
    private static interface HandlerInterface {}
    private static class A {}
    private static class B {}
    private static class C extends B {}
    private static class D extends B {}

    private HandlerRegistry<Class<?>, HandlerInterface> handlerRegistry;

    @Before
    public void setup(){

    }

    @Test(expected=IllegalArgumentException.class)
    public void shouldNotCreateWithNullHandlerLookupStrategy()
    {
        new DefaultHandlerRegistry<Class<?>, HandlerInterface>(null);
    }

    @Test(expected=IllegalArgumentException.class)
    public void findHandlerShouldNotAllowNullClass() {
        handlerRegistry = HandlerRegistries.typeHandlerRegistry(ImmutableMap.<Class<?>, HandlerInterface>of());
        handlerRegistry.findHandlerFor(null);
    }


    @Test(expected=IllegalArgumentException.class)
    public void addHandlerShouldNotAllowNullClass() {
        HandlerRegistries
            .typeHandlerRegistry(HandlerInterface.class)
            .addHandler(null, anyHandler());
    }

    @Test(expected=IllegalArgumentException.class)
    public void addHandlerShouldNotAllowNullHandler() {
        HandlerRegistries
            .typeHandlerRegistry(HandlerInterface.class)
            .addHandler(A.class, null);
    }

    @Test(expected=IllegalArgumentException.class)
    public void addHandlerForSeveralClassesShouldNotAllowNullHandler() {
        HandlerRegistries
            .typeHandlerRegistry(HandlerInterface.class)
            .addHandlerForSeveralKeys(ImmutableSet.of(A.class), null);
    }

    private HandlerInterface anyHandler()
    {
        return mock(HandlerInterface.class);
    }

    @Test
    public void shouldFindHandler() {
        HandlerInterface aHandler = mock(HandlerInterface.class);
        HandlerInterface bHandler = mock(HandlerInterface.class);

        HandlerRegistry<Class<?>, HandlerInterface> handlerRegistry =
            HandlerRegistries
                .typeHandlerRegistry(HandlerInterface.class)
                .addHandler(A.class, aHandler)
                .addHandler(B.class, bHandler)
                .buildTypeRegistry();

        Assert.assertSame(handlerRegistry.findHandlerFor(A.class), aHandler);
        Assert.assertSame(handlerRegistry.findHandlerFor(B.class), bHandler);
    }

    @Test
    public void shouldThrowExceptionWhenHandlerNotFound() {

        HandlerRegistry<Class<?>, HandlerInterface> handlerRegistry =
            HandlerRegistries
                .typeHandlerRegistry(HandlerInterface.class)
                .buildTypeRegistry();
        try {
            handlerRegistry.findHandlerFor(A.class);
        } catch(NoMatchingHandlerFoundException e) {
            Assert.assertEquals(e.getKey(), A.class);
        }
    }

    @Test
    public void shouldFindHandlerAddedForSeveralClasses() {
        HandlerInterface aHandler = mock(HandlerInterface.class);
        HandlerInterface bHandler = mock(HandlerInterface.class);

        HandlerRegistry<Class<?>, HandlerInterface> handlerRegistry =
            HandlerRegistries
                .typeHandlerRegistry(HandlerInterface.class)
                .addHandlerForSeveralKeys(ImmutableSet.of(A.class, C.class), aHandler)
                .addHandler(B.class, bHandler)
                .buildTypeRegistry();


        Assert.assertSame(handlerRegistry.findHandlerFor(A.class), aHandler) ;
        Assert.assertSame(handlerRegistry.findHandlerFor(C.class), aHandler) ;
        Assert.assertSame(handlerRegistry.findHandlerFor(B.class), bHandler) ;
    }

    @Test
    public void shouldFindMostSpecificHandler() {
        HandlerInterface aHandler = mock(HandlerInterface.class);
        HandlerInterface bHandler = mock(HandlerInterface.class);
        HandlerInterface cHandler = mock(HandlerInterface.class);
        HandlerInterface dHandler = mock(HandlerInterface.class);

        HandlerRegistry<Class<?>, HandlerInterface> handlerRegistry =
            HandlerRegistries
                .typeHandlerRegistry(HandlerInterface.class)
                .addHandler(C.class, cHandler)
                .addHandler(A.class, aHandler)
                .addHandler(B.class, bHandler)
                .addHandler(D.class, dHandler)
                .buildTypeRegistry();

        Assert.assertSame(handlerRegistry.findHandlerFor(A.class), aHandler) ;
        Assert.assertSame(handlerRegistry.findHandlerFor(B.class), bHandler) ;
        Assert.assertSame(handlerRegistry.findHandlerFor(C.class), cHandler) ;
        Assert.assertSame(handlerRegistry.findHandlerFor(D.class), dHandler) ;
    }


}