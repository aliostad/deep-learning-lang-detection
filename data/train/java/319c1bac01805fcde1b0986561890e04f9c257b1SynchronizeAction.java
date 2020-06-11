package com.citsamex.service.action;

import com.citsamex.app.action.BaseAction;
import com.citsamex.service.ICompanyService;
import com.citsamex.service.ICustomerService;
import com.citsamex.service.ITravelerService;

public class SynchronizeAction extends BaseAction {
	private static final long serialVersionUID = 6289667645711346011L;

	private ICompanyService cService;
	private ICustomerService gService;
	private ITravelerService tService;

	public ICompanyService getcService() {
		return cService;
	}

	public void setcService(ICompanyService cService) {
		this.cService = cService;
	}

	public ICustomerService getgService() {
		return gService;
	}

	public void setgService(ICustomerService gService) {
		this.gService = gService;
	}

	public ITravelerService gettService() {
		return tService;
	}

	public void settService(ITravelerService tService) {
		this.tService = tService;
	}

	public void synchronize() {

	}

}
