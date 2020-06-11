/*
 * Copyright (c) 2013 Sanxing Electric, Inc.
 * All Rights Reserved.
 */
package com.sanxing.sesame.wtc.proxy;

/**
 * @author ShangjieZhou
 */
public class WTCProxy
{
    private WTCHandler handler;

    /**
     * handler
     * 
     * @return handler
     */
    public WTCHandler getHandler()
    {
        return handler;
    }

    /**
     * @param handler
     */
    public void setHandler( WTCHandler handler )
    {
        this.handler = handler;
    }

    /**
     * @param handler
     */
    public void register( WTCHandler handler )
    {
        setHandler( handler );
    }

    /**
     * @param request
     * @return response
     */
    public WTCResponse process( WTCRequest request )
    {
        return this.handler.handle( request );
    }
}
