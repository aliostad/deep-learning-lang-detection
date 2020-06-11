package com.ebiz.bp_oracle.service;

import com.ebiz.ssi.service.BaseFacade;

public interface Facade extends BaseFacade {

	BaseAttributeService getBaseAttributeService();

	BaseAttributeSonService getBaseAttributeSonService();

	BaseBrandInfoService getBaseBrandInfoService();

	BaseClassLinkAttributeService getBaseClassLinkAttributeService();

	BaseClassService getBaseClassService();

	BaseDataService getBaseDataService();

	BasePdClazzService getBasePdClazzService();

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

	MailAttachmentService getMailAttachmentService();

	MailMainService getMailMainService();

	MailPeopService getMailPeopService();
}
