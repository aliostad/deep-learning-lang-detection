package com.ebiz.bp_mysql.service;

import com.ebiz.ssi.service.BaseFacade;

public interface Facade extends BaseFacade {

	BaseAttributeService getBaseAttributeService();

	BaseAttributeSonService getBaseAttributeSonService();

	BaseBrandInfoService getBaseBrandInfoService();

	BaseClassLinkAttributeService getBaseClassLinkAttributeService();

	BaseClassService getBaseClassService();

	BaseDataService getBaseDataService();

	BasePopedomService getBasePopedomService();

	BaseProvinceService getBaseProvinceService();

	DeptInfoService getDeptInfoService();

	HelpContentService getHelpContentService();

	HelpInfoService getHelpInfoService();

	HelpModuleService getHelpModuleService();

	ModPopedomService getModPopedomService();

	NewsAttachmentService getNewsAttachmentService();

	NewsContentService getNewsContentService();

	NewsInfoService getNewsInfoService();

	PdContentService getPdContentService();

	PdImgsService getPdImgsService();

	PdInfoCustomAttrContentService getPdInfoCustomAttrContentService();

	PdInfoCustomFieldContentService getPdInfoCustomFieldContentService();

	PdInfoService getPdInfoService();

	QaInfoService getQaInfoService();

	RoleService getRoleService();

	RoleUserService getRoleUserService();

	SysModuleService getSysModuleService();

	SysSettingService getSysSettingService();

	UserInfoService getUserInfoService();

}