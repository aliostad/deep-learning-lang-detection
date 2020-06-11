package it.pkg.handle;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * ExceptionHandlerFactory para gerenciar os erros nao tratados
 * 
 * @see ApplicationExceptionHandler
 * @author ayslan
 */
public class ApplicationExceptionHandlerFactory extends ExceptionHandlerFactory{

    private ExceptionHandlerFactory parent;

    public ApplicationExceptionHandlerFactory(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
        ExceptionHandler result =
                new ApplicationExceptionHandler(parent.getExceptionHandler());
        return result;
    }
}
