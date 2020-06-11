package cgwap.util.exception_handler;

import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

/**
 * Creates (if needed) and returns a new instance of CGWAPExceptionHandler.
 * 
 * 
 */
public class CGWAPExceptionHandlerFactory extends ExceptionHandlerFactory {

    private ExceptionHandlerFactory parent;

    /**
     * Constructor with parameter to set parent ExceptionHandlerFactory.
     * 
     * @param parent - parent ExceptionHandlerFactory
     */
    public CGWAPExceptionHandlerFactory(ExceptionHandlerFactory parent) {
        this.parent = parent;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public ExceptionHandler getExceptionHandler() {
        ExceptionHandler handler = new CGWAPExceptionHandler(parent.getExceptionHandler());
        return handler;
    }

}
