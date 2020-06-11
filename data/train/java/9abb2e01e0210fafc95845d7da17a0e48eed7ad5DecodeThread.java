package com.wang.chatlib.qrcode;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

/**
 * Created by shawn on 9/5/15.
 */
public class DecodeThread extends Thread{
    private Handler mDecodeHandler;
    private Handler mResultHandler;

    public DecodeThread(Handler resultHandler){
        mResultHandler = resultHandler;
    }

    public Handler getDecodeHandler(){
        return mDecodeHandler;
    }

    @Override
    public void run() {
        Log.d("DecodeThread","run()");
        Looper.prepare();
        mDecodeHandler = new DecodeHandler(mResultHandler);

        Looper.loop();
    }
}
