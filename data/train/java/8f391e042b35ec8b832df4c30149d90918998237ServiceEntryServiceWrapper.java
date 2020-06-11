/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package vn.com.fis.portal.service;

import com.liferay.portal.service.ServiceWrapper;

/**
 * <p>
 * This class is a wrapper for {@link ServiceEntryService}.
 * </p>
 *
 * @author    loind
 * @see       ServiceEntryService
 * @generated
 */
public class ServiceEntryServiceWrapper implements ServiceEntryService,
	ServiceWrapper<ServiceEntryService> {
	public ServiceEntryServiceWrapper(ServiceEntryService serviceEntryService) {
		_serviceEntryService = serviceEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #getWrappedService}
	 */
	public ServiceEntryService getWrappedServiceEntryService() {
		return _serviceEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #setWrappedService}
	 */
	public void setWrappedServiceEntryService(
		ServiceEntryService serviceEntryService) {
		_serviceEntryService = serviceEntryService;
	}

	public ServiceEntryService getWrappedService() {
		return _serviceEntryService;
	}

	public void setWrappedService(ServiceEntryService serviceEntryService) {
		_serviceEntryService = serviceEntryService;
	}

	private ServiceEntryService _serviceEntryService;
}