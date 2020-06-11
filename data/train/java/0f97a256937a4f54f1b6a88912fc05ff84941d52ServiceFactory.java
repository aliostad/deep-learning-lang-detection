package com.elulian.CustomerSecurityManagementSystem.service;

import com.elulian.CustomerSecurityManagementSystem.service.impl.CustomerInfoService;
import com.elulian.CustomerSecurityManagementSystem.service.impl.RiskRankService;
import com.elulian.CustomerSecurityManagementSystem.service.impl.ThresholdService;
import com.elulian.CustomerSecurityManagementSystem.service.impl.UserInfoService;

/**
 * 
 * @deprecated Replaced by spring IOC
 * 
 * @author elulian
 *
 */

@Deprecated
public class ServiceFactory {
	private static ServiceFactory factory;

	private IThresholdService thresholdService;

	private IUserInfoService userInfoService;

	private IRiskRankService riskRankService;

	private ICustomerInfoService customerInfoService;

	private ServiceFactory() {

	}

	public static ServiceFactory getServiceFactory() {
		if (factory == null) {
			synchronized (ServiceFactory.class) {
				if (factory == null)
					factory = new ServiceFactory();
			}
		}
		return factory;
	}

	public IThresholdService getIThresholdService() {
		if (thresholdService == null) {
			if (thresholdService == null)
				synchronized (this) {
					thresholdService = new ThresholdService();
				}
		}
		return thresholdService;
	}

	public IUserInfoService getIUserInfoService() {
		if (userInfoService == null) {
			if (userInfoService == null)
				synchronized (this) {
					userInfoService = new UserInfoService();
				}
		}
		return userInfoService;
	}

	public IRiskRankService getIRiskRankService() {
		if (riskRankService == null) {
			if (riskRankService == null)
				synchronized (this) {
					riskRankService = new RiskRankService();
				}
		}
		return riskRankService;
	}

	public ICustomerInfoService getICustomerInfoService() {
		if (customerInfoService == null) {
			if (customerInfoService == null)
				synchronized (this) {
					customerInfoService = new CustomerInfoService();
				}
		}
		return customerInfoService;
	}

}
