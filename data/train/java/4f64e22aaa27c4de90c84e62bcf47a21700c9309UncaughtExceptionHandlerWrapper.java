package fix.java.util.concurrent;

/**
 * Created by lin on 2014/7/22.
 */
public class UncaughtExceptionHandlerWrapper implements Thread.UncaughtExceptionHandler {
    public final static String TAG = UncaughtExceptionHandlerWrapper.class.getName();

    public static Thread.UncaughtExceptionHandler defaultHandler = new Thread.UncaughtExceptionHandler() {
        @Override
        public void uncaughtException(Thread thread, Throwable throwable) {
            // maybe you can save this exception data
        }
    };

    private final Thread.UncaughtExceptionHandler originalHandler;

    private UncaughtExceptionHandlerWrapper(Thread.UncaughtExceptionHandler originalHandler) {
        this.originalHandler = originalHandler;
    }

    @Override
    public void uncaughtException(Thread thread, Throwable throwable) {
        // print error
        throwable.printStackTrace();
        if (defaultHandler != null) {
            defaultHandler.uncaughtException(thread, throwable);
        }
        if (originalHandler != null) {
            originalHandler.uncaughtException(thread, throwable);
        }
    }

    public static Thread.UncaughtExceptionHandler wrap(Thread.UncaughtExceptionHandler handler) {
        Thread.UncaughtExceptionHandler wrapper = null;
        if (handler instanceof UncaughtExceptionHandlerWrapper) {
            wrapper = handler;
        } else {
            wrapper = new UncaughtExceptionHandlerWrapper(handler);
        }
        return wrapper;
    }
}
