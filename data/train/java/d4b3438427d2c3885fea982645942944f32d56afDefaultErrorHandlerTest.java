package org.javnce.eventing;

import org.junit.Test;

public class DefaultErrorHandlerTest {

    @Test
    public void testFatalError() {
        class TestErrorHandler extends DefaultErrorHandler {

            @Override
            protected void exit() {
            }
        }

        DefaultErrorHandler handler = new TestErrorHandler();
        // No catch here
        handler.fatalError(null, null);
        handler.fatalError(handler, null);
        handler.fatalError(handler, new Throwable());
    }
}
