package com.app_client.engine;

import com.app_client.interfaces.NetworkServiceInterface;

public class NetworkServiceProvider
{

	private static NetworkServiceInterface networkService;
	
	public static void setNetworkService(NetworkServiceInterface networkService)
	{
		if(networkService == null)
			throw new NullPointerException();
		else
			NetworkServiceProvider.networkService = networkService;
	}
	
	public static NetworkServiceInterface getNetworkService()
	{
		return networkService;
	}

}
