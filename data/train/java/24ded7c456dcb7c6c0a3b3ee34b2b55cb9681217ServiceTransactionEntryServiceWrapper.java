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
 * This class is a wrapper for {@link ServiceTransactionEntryService}.
 * </p>
 *
 * @author    loind
 * @see       ServiceTransactionEntryService
 * @generated
 */
public class ServiceTransactionEntryServiceWrapper
	implements ServiceTransactionEntryService,
		ServiceWrapper<ServiceTransactionEntryService> {
	public ServiceTransactionEntryServiceWrapper(
		ServiceTransactionEntryService serviceTransactionEntryService) {
		_serviceTransactionEntryService = serviceTransactionEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #getWrappedService}
	 */
	public ServiceTransactionEntryService getWrappedServiceTransactionEntryService() {
		return _serviceTransactionEntryService;
	}

	/**
	 * @deprecated Renamed to {@link #setWrappedService}
	 */
	public void setWrappedServiceTransactionEntryService(
		ServiceTransactionEntryService serviceTransactionEntryService) {
		_serviceTransactionEntryService = serviceTransactionEntryService;
	}

	public ServiceTransactionEntryService getWrappedService() {
		return _serviceTransactionEntryService;
	}

	public void setWrappedService(
		ServiceTransactionEntryService serviceTransactionEntryService) {
		_serviceTransactionEntryService = serviceTransactionEntryService;
	}

	private ServiceTransactionEntryService _serviceTransactionEntryService;
}