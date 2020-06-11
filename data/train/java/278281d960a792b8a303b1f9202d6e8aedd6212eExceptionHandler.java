package lza.com.lza.library.exception;

/**
 * Say something about this class
 *
 * @author xiads
 * @Date 5/7/15.
 */
public class ExceptionHandler implements Thread.UncaughtExceptionHandler {

    private Thread.UncaughtExceptionHandler previousHandler;

    public ExceptionHandler(Thread.UncaughtExceptionHandler handler) {
        this.previousHandler = handler;
    }

    @Override
    public void uncaughtException(Thread thread, Throwable ex) {
        previousHandler.uncaughtException(thread, ex);
    }
}
