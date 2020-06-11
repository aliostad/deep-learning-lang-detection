package com.bardframework.bard.core;

import java.lang.annotation.Annotation;

public class AnnotatedHandler<HandlerClass extends GenericHandler> {
    public Annotation annotation;
    public Class<HandlerClass> handlerClass;

    private HandlerFactory handlerFactory;

    public AnnotatedHandler(Annotation annotation, Class<HandlerClass> handlerClass) {
        this.annotation = annotation;
        this.handlerClass = handlerClass;
        for (Annotation a : handlerClass.getAnnotations()) {
            handlerFactory = HandlerMeta.getHandlerFactory(a.annotationType());
            if (handlerFactory != null) {
                break;
            }
        }
        if (handlerFactory == null) {
            handlerFactory = new DefaultHandlerFactory();
        }
    }

    public HandlerClass newInstance() throws HandlerFactory.HandlerInitException {
        return handlerFactory.initHandler(handlerClass);
    }

}
