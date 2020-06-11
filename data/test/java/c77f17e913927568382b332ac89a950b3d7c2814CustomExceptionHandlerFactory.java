package org.sandbox.javaee.errors;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class CustomExceptionHandlerFactory extends ExceptionHandlerFactory {

    private ExceptionHandlerFactory paarentFactory;
    private static Logger logger = LoggerFactory.getLogger(CustomExceptionHandlerFactory.class);

    public CustomExceptionHandlerFactory(ExceptionHandlerFactory exceptionHandlerFactory) {
        logger.info("SampleExceptionHandlerFactory.init");
        this.paarentFactory = exceptionHandlerFactory;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
        logger.debug("SampleExceptionHandlerFactory.getExceptionHandler");
        ExceptionHandler result = paarentFactory.getExceptionHandler();
        result = new CustomExceptionHandler(result);
        return result;
    }

}