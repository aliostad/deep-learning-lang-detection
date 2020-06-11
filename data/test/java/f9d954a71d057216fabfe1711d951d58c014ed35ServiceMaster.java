package com.sales.wb.common.constrains;


import com.sales.wb.service.MasterService;
import com.sales.wb.service.imp.MasterServiceImpService;


public class ServiceMaster {

	public static MasterService masterService;
	static {
		masterService = new MasterServiceImpService().getMasterServiceImpPort();
		System.out.println("All Service Port Created Successfully...");
	}
	public static MasterService getMasterService() {
		return masterService;
	}
	public static void setMasterService(MasterService masterService) {
		ServiceMaster.masterService = masterService;
	}
}
