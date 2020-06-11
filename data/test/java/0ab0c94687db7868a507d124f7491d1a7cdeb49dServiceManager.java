/**
 *
 */
package com.binaryedu.business.service;

import com.binaryedu.business.service.impl.AccountService;
import com.binaryedu.business.service.impl.CommunicationService;
import com.binaryedu.business.service.impl.TestService;
import com.binaryedu.business.service.impl.UserService;

/**
 * @author parsingh
 * 
 */
public class ServiceManager
{
	public static IUserService getUserService()
	{
		return UserService.getInstance();
	}

	public static IAccountService getAccountService()
	{
		return AccountService.getInstance();
	}

	public static ICommunicationService getCommunictionService()
	{
		return CommunicationService.getInstance();
	}

	public static ITestService getTestService()
	{
		return TestService.getInstance();
	}
}
