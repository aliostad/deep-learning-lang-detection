package fm.jopp.android.background.util;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;

import com.announcify.api.background.error.ExceptionHandler;

public class HandlerCreator {

    public static Handler create(final String name, final Context context) {
        final HandlerThread thread = new HandlerThread("JOPPFM - " + name);
        thread.start();

        final Handler handler = new Handler(thread.getLooper());
        handler.post(new Runnable() {

            @Override
            public void run() {
                Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler(context));
            }
        });

        return handler;
    }
}
