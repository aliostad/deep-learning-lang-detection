package com.cwa.service.service;

import Ice.Current;
import baseice.service.FunctionMenu;
import baseice.service._IMasterServiceDisp;

import com.cwa.service.service.interf.IMasterServiceI;

public class MasterServiceI extends _IMasterServiceDisp {
	private static final long serialVersionUID = 1L;

	private IMasterServiceI service;

	@Override
	public FunctionMenu getFunctionMenu(Current __current) {
		return service.getFunctionMenu();
	}

	// --------------------------------------------
	public void setService(IMasterServiceI service) {
		this.service = service;
	}
}
