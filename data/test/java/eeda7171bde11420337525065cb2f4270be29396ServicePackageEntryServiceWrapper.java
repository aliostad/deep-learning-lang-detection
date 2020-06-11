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
 * This class is a wrapper for {@link ServicePackageEntryService}.
 * </p>
 *
 * @author    loind
 * @see       ServicePackageEntryService
 * @generated
 */
public class ServicePackageEntryServiceWrapper
	implements ServicePackageEntryService,
		ServiceWrapper<ServicePackageEntryService> {
	public ServicePackageEntryServiceWrapper(
		ServicePackageEntryService servicePackageEntryService) {
		_servicePackageEntryService = servicePackageEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #getWrappedService}
	 */
	public ServicePackageEntryService getWrappedServicePackageEntryService() {
		return _servicePackageEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #setWrappedService}
	 */
	public void setWrappedServicePackageEntryService(
		ServicePackageEntryService servicePackageEntryService) {
		_servicePackageEntryService = servicePackageEntryService;
	}

	public ServicePackageEntryService getWrappedService() {
		return _servicePackageEntryService;
	}

	public void setWrappedService(
		ServicePackageEntryService servicePackageEntryService) {
		_servicePackageEntryService = servicePackageEntryService;
	}

	private ServicePackageEntryService _servicePackageEntryService;
}