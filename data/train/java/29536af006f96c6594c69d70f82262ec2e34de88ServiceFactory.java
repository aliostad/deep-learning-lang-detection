package it.dariofabbri.accesscontrol.service.local;

import it.dariofabbri.accesscontrol.service.local.accesso.AccessoService;
import it.dariofabbri.accesscontrol.service.local.accesso.AccessoServiceImpl;
import it.dariofabbri.accesscontrol.service.local.contact.ContactService;
import it.dariofabbri.accesscontrol.service.local.contact.ContactServiceImpl;
import it.dariofabbri.accesscontrol.service.local.lut.LUTService;
import it.dariofabbri.accesscontrol.service.local.lut.LUTServiceImpl;
import it.dariofabbri.accesscontrol.service.local.permission.PermissionService;
import it.dariofabbri.accesscontrol.service.local.permission.PermissionServiceImpl;
import it.dariofabbri.accesscontrol.service.local.postazione.PostazioneService;
import it.dariofabbri.accesscontrol.service.local.postazione.PostazioneServiceImpl;
import it.dariofabbri.accesscontrol.service.local.report.ReportService;
import it.dariofabbri.accesscontrol.service.local.role.RoleService;
import it.dariofabbri.accesscontrol.service.local.role.RoleServiceImpl;
import it.dariofabbri.accesscontrol.service.local.security.SecurityService;
import it.dariofabbri.accesscontrol.service.local.security.SecurityServiceImpl;
import it.dariofabbri.accesscontrol.service.local.user.UserService;
import it.dariofabbri.accesscontrol.service.local.user.UserServiceImpl;
import it.dariofabbri.accesscontrol.service.local.visitatore.VisitatoreService;
import it.dariofabbri.accesscontrol.service.local.visitatore.VisitatoreServiceImpl;

public class ServiceFactory {
	
	public static SecurityService createSecurityService() {
		
		SecurityService service = SessionDecorator.<SecurityService>createProxy(new SecurityServiceImpl(), SecurityService.class);
		return service;
	}
	
	public static ContactService createContactService() {
		
		ContactService service = SessionDecorator.<ContactService>createProxy(new ContactServiceImpl(), ContactService.class);
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
	
	public static AccessoService createAccessoService() {
		
		AccessoService service = SessionDecorator.<AccessoService>createProxy(new AccessoServiceImpl(), AccessoService.class);
		return service;
	}
	
	public static VisitatoreService createVisitatoreService() {
		
		VisitatoreService service = SessionDecorator.<VisitatoreService>createProxy(new VisitatoreServiceImpl(), VisitatoreService.class);
		return service;
	}
	
	public static ReportService createReportService() {
		
		ReportService service = new ReportService();
		return service;
	}
	
	public static PostazioneService createPostazioneService() {
		
		PostazioneService service = SessionDecorator.<PostazioneService>createProxy(new PostazioneServiceImpl(), PostazioneService.class);
		return service;
	}
}