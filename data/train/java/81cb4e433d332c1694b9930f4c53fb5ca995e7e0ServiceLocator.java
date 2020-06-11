package com.cloudecp.platform.common.service;

import com.cloudecp.ade.manage.service.AdeClazzesService;
import com.cloudecp.ade.manage.service.AdeService;
import com.cloudecp.ade.manage.service.HolidayService;
import com.cloudecp.ade.manage.service.WorkTimeService;
import com.cloudecp.platform.common.util.SpringHelper;
import com.cloudecp.platform.system.service.*;

/**
 * 
 * @author jack
 */
public class ServiceLocator {
	public static final String COMPANY_SERVICE = "companyService";
	public static final String USER_SERVICE = "userService";
	public static final String RESOURCETYPE_SERVICE = "resourceTypeService";
	public static final String SECURITY_SERVICE = "securityService";
	public static final String ATTACHMENT_SERVICE = "attachmentService";
	public static final String SMS_SERVICE = "SMSService";
	public static final String PROVINCECITY_SERVICE = "provinceCityService";

	public static final String SUBSYSTEM_SERVICE = "subSystemService";
	public static final String DEPT_SERVICE = "deptService";
	public static final String LOG_SERVICE = "logService";
	public static final String ONLINEUSER_SERVICE = "onlineUserService";
	public static final String IDENTITY_SERVICE = "identityService";
	public static final String AGENCY_SERVICE = "agencyService";
	public static final String NOTICE_SERVICE = "noticeService";
	public static final String PROVIDER_SERVICE = "providerService";
	public static final String REGISTER_SERVICE = "registerService";
	public static final String ROLE_SERVICE = "roleService";
	public static final String MENU_SERVICE = "menuService";
	
	public static final String ADE_SERVICE = "AdeService";
	public static final String ADE_CLAZZES_SERVICE = "AdeClazzesService";
	public static final String ADE_WORKTIME_SERVICE = "workTimeService";
	public static final String ADE_HOLIDAY_SERVICE = "holidayService";
	
	public static HolidayService getHolidayService() {
		return (HolidayService) SpringHelper.getSpringBean(ADE_HOLIDAY_SERVICE);
	}
	
	public static WorkTimeService getWorkTimeService() {
		return (WorkTimeService) SpringHelper.getSpringBean(ADE_WORKTIME_SERVICE);
	}
	
	public static AdeClazzesService getAdeClazzesService() {
		return (AdeClazzesService) SpringHelper.getSpringBean(ADE_CLAZZES_SERVICE);
	}
	
	public static AdeService getAdeService(){
		return (AdeService) SpringHelper.getSpringBean(ADE_SERVICE);
	}

	public static RegisterService getRegisterService() {
		return (RegisterService) SpringHelper.getSpringBean(REGISTER_SERVICE);
	}

	public static AttachmentService getAttachmentService() {
		return (AttachmentService) SpringHelper
				.getSpringBean(ATTACHMENT_SERVICE);
	}

	public static SecurityService getSecurityService() {
		return (SecurityService) SpringHelper.getSpringBean(SECURITY_SERVICE);
	}

	public static UserService getUserService() {
		return (UserService) SpringHelper.getSpringBean(USER_SERVICE);
	}

	public static CompanyService getCompanyService() {
		return (CompanyService) SpringHelper.getSpringBean(COMPANY_SERVICE);
	}

	public static ResourceTypeService getResourceTypeService() {
		return (ResourceTypeService) SpringHelper
				.getSpringBean(RESOURCETYPE_SERVICE);
	}

	public static SMSService getSMSService() {
		return (SMSService) SpringHelper.getSpringBean(SMS_SERVICE);
	}

	public static ProvinceCityService getProvinceCityService() {
		return (ProvinceCityService) SpringHelper
				.getSpringBean(PROVINCECITY_SERVICE);
	}

	public static SubSystemService getSubSystemService() {
		return (SubSystemService) SpringHelper.getSpringBean(SUBSYSTEM_SERVICE);
	}

	public static DeptService getDeptService() {
		return (DeptService) SpringHelper.getSpringBean(DEPT_SERVICE);
	}

	public static LogService getLogService() {
		return (LogService) SpringHelper.getSpringBean(LOG_SERVICE);
	}

	public static OnlineUserService getOnlineUserService() {
		return (OnlineUserService) SpringHelper
				.getSpringBean(ONLINEUSER_SERVICE);
	}

	public static IdentityService getIdentityService() {
		return (IdentityService) SpringHelper.getSpringBean(IDENTITY_SERVICE);
	}

	public static AgencyService getAgencyService() {
		return (AgencyService) SpringHelper.getSpringBean(AGENCY_SERVICE);
	}

	public static NoticeService getNoticeService() {
		return (NoticeService) SpringHelper.getSpringBean(NOTICE_SERVICE);
	}

	public static ProviderService getProviderService() {
		return (ProviderService) SpringHelper.getSpringBean(PROVIDER_SERVICE);
	}

	public static RoleService getRoleService() {
		return (RoleService) SpringHelper.getSpringBean(ROLE_SERVICE);
	}

	public static MenuService getMenuService() {
		return (MenuService) SpringHelper.getSpringBean(MENU_SERVICE);
	}
}
