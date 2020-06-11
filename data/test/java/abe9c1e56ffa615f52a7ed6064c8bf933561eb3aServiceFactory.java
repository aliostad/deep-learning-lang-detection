package com.talool.service;

import com.talool.core.service.ActivityService;
import com.talool.core.service.AnalyticService;
import com.talool.core.service.CustomerService;
import com.talool.core.service.EmailService;
import com.talool.core.service.TaloolService;

/**
 * 
 * 
 * 
 * @author clintz
 */
public final class ServiceFactory
{
	private static ServiceFactory instance;
	private TaloolService taloolService;
	private CustomerService customerService;
	private EmailService emailService;
	private ActivityService activityService;
	private AnalyticService analyticService;
	private MessagingService messagingService;

	private ServiceFactory()
	{}

	public static ServiceFactory get()
	{
		return instance;
	}

	public static synchronized ServiceFactory createInstance(final TaloolService taloolService, final CustomerService customerService,
			final EmailService emailService, final ActivityService activityService, final AnalyticService analyticService,
			final MessagingService messagingService)
	{
		if (instance == null)
		{
			instance = new ServiceFactory();
			instance.taloolService = taloolService;
			instance.customerService = customerService;
			instance.emailService = emailService;
			instance.activityService = activityService;
			instance.analyticService = analyticService;
			instance.messagingService = messagingService;
		}

		return instance;
	}

	public TaloolService getTaloolService()
	{
		return taloolService;
	}

	public ActivityService getActivityService()
	{
		return activityService;
	}

	public AnalyticService getAnalyticService()
	{
		return analyticService;
	}

	public CustomerService getCustomerService()
	{
		return customerService;
	}

	public MessagingService getMessagingService()
	{
		return messagingService;
	}

	public EmailService getEmailService()
	{
		return emailService;
	}

}
