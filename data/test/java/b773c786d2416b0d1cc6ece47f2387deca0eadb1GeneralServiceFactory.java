package com.fancl.iloyalty.factory;

import com.fancl.iloyalty.AndroidProjectApplication;
import com.fancl.iloyalty.service.ActivityMonitorService;
import com.fancl.iloyalty.service.AlertDialogService;
import com.fancl.iloyalty.service.DatabaseDownloadService;
import com.fancl.iloyalty.service.HttpConnectionService;
import com.fancl.iloyalty.service.ImageService;
import com.fancl.iloyalty.service.LocaleService;
import com.fancl.iloyalty.service.SQLiteDatabaseService;
import com.fancl.iloyalty.service.ThreadService;
import com.fancl.iloyalty.service.impl.ActivityMonitorServiceImpl;
import com.fancl.iloyalty.service.impl.AlertDialogServiceImpl;
import com.fancl.iloyalty.service.impl.DatabaseDownloadServiceImpl;
import com.fancl.iloyalty.service.impl.HttpConnectionServiceImpl;
import com.fancl.iloyalty.service.impl.ImageServiceImpl;
import com.fancl.iloyalty.service.impl.LocaleServiceImpl;
import com.fancl.iloyalty.service.impl.SQLiteDatabaseServiceImpl;
import com.fancl.iloyalty.service.impl.ThreadServiceImpl;

public class GeneralServiceFactory {
	
	/**
	 * General Application Service Object
	 * General Service Object for Any Project
	 */
	private static HttpConnectionService httpConnectionService;
	private static ImageService imageService;
	private static ThreadService threadService;
	private static LocaleService localeService;
	private static AlertDialogService alertDialogService;
	private static ActivityMonitorService activityMonitorService;
	private static DatabaseDownloadService databaseDownloadService;
	private static SQLiteDatabaseService sqLiteDatabaseService;
	
	public static HttpConnectionService getHttpConnectionService(AndroidProjectApplication application)
	{
		if(httpConnectionService == null)
		{
			httpConnectionService = new HttpConnectionServiceImpl(application);
		}
		
		return httpConnectionService;
	}
	
	public static ImageService getImageService()
	{
		if(imageService == null)
		{
			imageService = new ImageServiceImpl();
		}
		
		return imageService;
	}
	
	public static ThreadService getThreadService()
	{
		if(threadService == null)
		{
			threadService = new ThreadServiceImpl();
		}
		
		return threadService;
	}
	
	public static LocaleService getLocaleService()
	{
		if(localeService == null)
		{
			localeService = new LocaleServiceImpl();
		}
		
		return localeService;
	}
	
	public static AlertDialogService getAlertDialogService()
	{
		if(alertDialogService == null)
		{
			alertDialogService = new AlertDialogServiceImpl();
		}
		
		return alertDialogService;
	}
	
	public static ActivityMonitorService getActivityMonitorService()
	{
		if(activityMonitorService == null)
		{
			activityMonitorService = new ActivityMonitorServiceImpl();
		}
		
		return activityMonitorService;
	}
	
	public static DatabaseDownloadService getDatabaseDownloadService()
	{
		if(databaseDownloadService == null)
		{
			databaseDownloadService = new DatabaseDownloadServiceImpl();
		}
		
		return databaseDownloadService;
	}
	
	public static SQLiteDatabaseService getSQLiteDatabaseService()
	{
		if (sqLiteDatabaseService == null)
		{
			sqLiteDatabaseService = new SQLiteDatabaseServiceImpl();
		}
		return sqLiteDatabaseService;
	}
}
