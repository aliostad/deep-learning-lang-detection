package com.achievo.sample.designpatterns.chain;

/**
 * <pre>
 * 
 *  Accela Automation
 *  File: AbstractHandler.java
 * 
 *  Accela, Inc.
 *  Copyright (C): 2015
 * 
 *  Description:
 *  TODO
 * 
 *  Notes:
 * 	$Id: AbstractHandler.java 72642 2009-01-01 20:01:57Z ACHIEVO\galen.zhang $ 
 * 
 *  Revision History
 *  &lt;Date&gt;,			&lt;Who&gt;,			&lt;What&gt;
 *  Jul 10, 2015		galen.zhang		Initial.
 * 
 * </pre>
 */
public abstract class AbstractHandler
{

	private Handler handler;

	public Handler getHandler()
	{
		return handler;
	}

	public void setHandler(Handler handler)
	{
		this.handler = handler;
	}

}

/*
 * $Log: av-env.bat,v $
 */