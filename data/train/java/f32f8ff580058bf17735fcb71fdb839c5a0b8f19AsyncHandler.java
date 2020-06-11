package videofactory.net.cookingclass.common;

import android.os.Handler;
import android.os.HandlerThread;

/**
 * Created by Hoony on 2017-04-19.
 */

public final class AsyncHandler {
    private static final HandlerThread aHandlerThread =
            new HandlerThread("AsyncHandler");
    private static final Handler aHandler;

    static {
        aHandlerThread.start();
        aHandler = new Handler(aHandlerThread.getLooper());
    }

    public static void post(Runnable r) {
        aHandler.post(r);
    }

    private AsyncHandler() {}
}
