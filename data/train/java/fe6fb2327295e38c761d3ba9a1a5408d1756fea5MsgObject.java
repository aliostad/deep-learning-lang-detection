package com.lenovohit.lrouter_api.core.socket;

import android.os.Handler;

/**
 * 发送的实体
 * Created by yuzhijun on 2017/6/13.
 */
public class MsgObject {
    //要发送的消息
    private byte [] bytes;
    //错误处理的handler
    private Handler mHandler;

    public MsgObject(byte [] bytes, Handler handler){
        this.bytes = bytes;
        mHandler = handler;
    }

    public byte []  getBytes()
    {
        return this.bytes;
    }

    public Handler getHandler()
    {
        return mHandler;
    }
}
