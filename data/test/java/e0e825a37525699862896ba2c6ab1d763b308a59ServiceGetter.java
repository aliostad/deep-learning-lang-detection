package com.dingfan.utils;

import com.dingfan.service.DingFanService;
import com.dingfan.service.SystemService;



public class ServiceGetter {
	private static ServiceGetter instance;
	private MailService mailService;
	private SystemService systemService;
	private DingFanService dingFanService;
	
	public ServiceGetter() {
		instance=this;
	}
	public static ServiceGetter getInstance() {
		return instance;
	}
	
	public MailService getMailService() {
		return mailService;
	}
	public void setMailService(MailService mailService) {
		this.mailService = mailService;
	}
	public SystemService getSystemService() {
		return systemService;
	}
	public void setSystemService(SystemService systemService) {
		this.systemService = systemService;
	}
	public DingFanService getDingFanService() {
		return dingFanService;
	}
	public void setDingFanService(DingFanService dingFanService) {
		this.dingFanService = dingFanService;
	}
}
