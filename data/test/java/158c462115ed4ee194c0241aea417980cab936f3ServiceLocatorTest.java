package com.momo.service;

import com.momo.service.interfaces.Service;
import com.momo.service.util.ServiceConstants;

public class ServiceLocatorTest  {
	public static void main(String[] args) {
	      Service service = ServiceLocator.getService(ServiceConstants.TASK_SERVICE);
	      service.execute();
	      service = ServiceLocator.getService(ServiceConstants.TEST_SERVICE);
	      service.execute();
	      service = ServiceLocator.getService(ServiceConstants.TASK_SERVICE);
	      service.execute();
	      service = ServiceLocator.getService(ServiceConstants.TEST_SERVICE);
	      service.execute();		
	   }
}
