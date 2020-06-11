package at.frohnwieser.mahut.webapp.handler;

import javax.annotation.Nonnull;
import javax.faces.context.ExceptionHandler;
import javax.faces.context.ExceptionHandlerFactory;

public class MahutExceptionHandlerFactory extends ExceptionHandlerFactory {
    private final ExceptionHandlerFactory m_fExHandlerFactory;

    public MahutExceptionHandlerFactory(@Nonnull final ExceptionHandlerFactory aExHandlerFactory) {
	m_fExHandlerFactory = aExHandlerFactory;
    }

    @Override
    public ExceptionHandler getExceptionHandler() {
	return new MahutExceptionHandler(m_fExHandlerFactory.getExceptionHandler());
    }
}
