package edu.nju.software.service.impl;

import edu.nju.software.service.AdminService;
import edu.nju.software.service.CompanyService;
import edu.nju.software.service.LogService;
import edu.nju.software.service.MemberService;
import edu.nju.software.service.NewsService;
import edu.nju.software.service.OutEmployeeService;
import edu.nju.software.service.WorkService;

public class ServiceFactory {
	
	private AdminService adminService;
	private CompanyService companyService;
	private LogService logService;
	private MemberService memberService;
	private NewsService newsService;
	private OutEmployeeService outEmployeeService;
	private WorkService workService;
	
	private static ServiceFactory instance = null;
	
	public static ServiceFactory instance() {
		if(null == instance) {
			instance = new ServiceFactory();
		}
		return instance;
	}

	public AdminService getAdminService() {
		if(null == adminService) {
			adminService = new AdminServiceImpl();
		}
		return adminService;
	}

	public CompanyService getCompanyService() {
		if(null == companyService) {
			companyService = new CompanyServiceImpl();
		}
		return companyService;
	}

	public LogService getLogService() {
		if(null == logService) {
			logService = new LogServiceImpl();
		}
		return logService;
	}

	public MemberService getMemberService() {
		if(null == memberService) {
			memberService = new MemberServiceImpl();
		}
		return memberService;
	}

	public NewsService getNewsService() {
		if(null == newsService) {
			newsService = new NewsServiceImpl();
		}
		return newsService;
	}

	public OutEmployeeService getOutEmployeeService() {
		if(null == outEmployeeService) {
			outEmployeeService = new OutEmployeeServiceImpl();
		}
		return outEmployeeService;
	}

	public WorkService getWorkService() {
		if(null == workService) {
			workService = new WorkServiceImpl();
		}
		return workService;
	}
	

}
