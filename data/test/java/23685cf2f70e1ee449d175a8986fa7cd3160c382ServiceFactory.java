package it.dariofabbri.ivncr.service.local;

import it.dariofabbri.ivncr.service.local.lut.LUTService;
import it.dariofabbri.ivncr.service.local.lut.LUTServiceImpl;
import it.dariofabbri.ivncr.service.local.permission.PermissionService;
import it.dariofabbri.ivncr.service.local.permission.PermissionServiceImpl;
import it.dariofabbri.ivncr.service.local.report.ReportService;
import it.dariofabbri.ivncr.service.local.role.RoleService;
import it.dariofabbri.ivncr.service.local.role.RoleServiceImpl;
import it.dariofabbri.ivncr.service.local.security.SecurityService;
import it.dariofabbri.ivncr.service.local.security.SecurityServiceImpl;
import it.dariofabbri.ivncr.service.local.user.UserService;
import it.dariofabbri.ivncr.service.local.user.UserServiceImpl;

public class ServiceFactory {
	
	public static SecurityService createSecurityService() {
		
		SecurityService service = SessionDecorator.<SecurityService>createProxy(new SecurityServiceImpl(), SecurityService.class);
		return service;
	}
	
	public static UserService createUserService() {
		
		UserService service = SessionDecorator.<UserService>createProxy(new UserServiceImpl(), UserService.class);
		return service;
	}
	
	public static RoleService createRoleService() {
		
		RoleService service = SessionDecorator.<RoleService>createProxy(new RoleServiceImpl(), RoleService.class);
		return service;
	}
	
	public static PermissionService createPermissionService() {
		
		PermissionService service = SessionDecorator.<PermissionService>createProxy(new PermissionServiceImpl(), PermissionService.class);
		return service;
	}
	
	public static LUTService createLUTService() {
		
		LUTService service = SessionDecorator.<LUTService>createProxy(new LUTServiceImpl(), LUTService.class);
		return service;
	}
	
	public static ReportService createReportService() {
		
		ReportService service = new ReportService();
		return service;
	}
}